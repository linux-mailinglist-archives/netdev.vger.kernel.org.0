Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7352A3D3E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgKCHLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgKCHLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:11:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC8BC0617A6;
        Mon,  2 Nov 2020 23:11:37 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604387495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFf5htu0FfepOMfTa5/FU41dRKj98uxqPqwL1LjFssc=;
        b=SGe2Q618zu823Wr8E/1zqVmz9i4xspcaJydOwTOCFZ3gYlObwsvf+qxx1ljCgGErHrcOKF
        bMapJdJDSTSCJqFnj/2Fzm6rKkJ2mOoY9NCAa6oPlL4+XGz/LS0j/vYTMwkFpA+0wafJz7
        S1YmK8aTiUjPs2IK7C0YKTv22fq4vJBc4U3QZIqpSK5rlsDGG+lodz0QmFKfRX4CJD/ujN
        +cKOMXRYPaaWg6OzH7P94LSc+YPf9quHO/cD0SePM9PH6OgYTUBjIzlJuWAOJQG/Y5pocZ
        izLHG1uNHhofjtqwJtO2zOlC/rk2m2JnGaz+g/3ZMk/wOjrT7axLwAgNz+4Fiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604387495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFf5htu0FfepOMfTa5/FU41dRKj98uxqPqwL1LjFssc=;
        b=ckGxULN4ipItr09ckAA1UlWVPEj6yH0v8RMLfqmIUXFd85FFZVJz5ncNO6rxh0Ah8tVrWd
        ST095FbTAMTYX1Bw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v8 3/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
Date:   Tue,  3 Nov 2020 08:10:56 +0100
Message-Id: <20201103071101.3222-4-kurt@linutronix.de>
In-Reply-To: <20201103071101.3222-1-kurt@linutronix.de>
References: <20201103071101.3222-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
implementing features needed for Time Sensitive Networking (TSN) such as support
for the Time Precision Protocol and various shapers like the Time Aware Shaper.

This driver includes basic support for networking:

 * VLAN handling
 * FDB handling
 * Port statistics
 * STP
 * Phylink

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/hirschmann/Kconfig            |    8 +
 drivers/net/dsa/hirschmann/Makefile           |    2 +
 drivers/net/dsa/hirschmann/hellcreek.c        | 1253 +++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h        |  249 ++++
 .../platform_data/hirschmann-hellcreek.h      |   23 +
 7 files changed, 1538 insertions(+)
 create mode 100644 drivers/net/dsa/hirschmann/Kconfig
 create mode 100644 drivers/net/dsa/hirschmann/Makefile
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
 create mode 100644 include/linux/platform_data/hirschmann-hellcreek.h

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 2451f61a38e4..f6a0488589fc 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -24,6 +24,8 @@ config NET_DSA_LOOP
 	  This enables support for a fake mock-up switch chip which
 	  exercises the DSA APIs.
 
+source "drivers/net/dsa/hirschmann/Kconfig"
+
 config NET_DSA_LANTIQ_GSWIP
 	tristate "Lantiq / Intel GSWIP"
 	depends on HAS_IOMEM && NET_DSA
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 4a943ccc2ca4..a84adb140a04 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
 obj-y				+= b53/
+obj-y				+= hirschmann/
 obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/
diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
new file mode 100644
index 000000000000..7d189cb936e3
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/Kconfig
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+config NET_DSA_HIRSCHMANN_HELLCREEK
+	tristate "Hirschmann Hellcreek TSN Switch support"
+	depends on HAS_IOMEM
+	depends on NET_DSA
+	select NET_DSA_TAG_HELLCREEK
+	help
+	  This driver adds support for Hirschmann Hellcreek TSN switches.
diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirschmann/Makefile
new file mode 100644
index 000000000000..0e12e149e40f
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek.o
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
new file mode 100644
index 000000000000..a4965a23db20
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -0,0 +1,1253 @@
+// SPDX-License-Identifier: (GPL-2.0 or MIT)
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_mdio.h>
+#include <linux/platform_device.h>
+#include <linux/bitops.h>
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/etherdevice.h>
+#include <linux/random.h>
+#include <linux/iopoll.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <net/dsa.h>
+
+#include "hellcreek.h"
+
+static const struct hellcreek_counter hellcreek_counter[] = {
+	{ 0x00, "RxFiltered", },
+	{ 0x01, "RxOctets1k", },
+	{ 0x02, "RxVTAG", },
+	{ 0x03, "RxL2BAD", },
+	{ 0x04, "RxOverloadDrop", },
+	{ 0x05, "RxUC", },
+	{ 0x06, "RxMC", },
+	{ 0x07, "RxBC", },
+	{ 0x08, "RxRS<64", },
+	{ 0x09, "RxRS64", },
+	{ 0x0a, "RxRS65_127", },
+	{ 0x0b, "RxRS128_255", },
+	{ 0x0c, "RxRS256_511", },
+	{ 0x0d, "RxRS512_1023", },
+	{ 0x0e, "RxRS1024_1518", },
+	{ 0x0f, "RxRS>1518", },
+	{ 0x10, "TxTailDropQueue0", },
+	{ 0x11, "TxTailDropQueue1", },
+	{ 0x12, "TxTailDropQueue2", },
+	{ 0x13, "TxTailDropQueue3", },
+	{ 0x14, "TxTailDropQueue4", },
+	{ 0x15, "TxTailDropQueue5", },
+	{ 0x16, "TxTailDropQueue6", },
+	{ 0x17, "TxTailDropQueue7", },
+	{ 0x18, "RxTrafficClass0", },
+	{ 0x19, "RxTrafficClass1", },
+	{ 0x1a, "RxTrafficClass2", },
+	{ 0x1b, "RxTrafficClass3", },
+	{ 0x1c, "RxTrafficClass4", },
+	{ 0x1d, "RxTrafficClass5", },
+	{ 0x1e, "RxTrafficClass6", },
+	{ 0x1f, "RxTrafficClass7", },
+	{ 0x21, "TxOctets1k", },
+	{ 0x22, "TxVTAG", },
+	{ 0x23, "TxL2BAD", },
+	{ 0x25, "TxUC", },
+	{ 0x26, "TxMC", },
+	{ 0x27, "TxBC", },
+	{ 0x28, "TxTS<64", },
+	{ 0x29, "TxTS64", },
+	{ 0x2a, "TxTS65_127", },
+	{ 0x2b, "TxTS128_255", },
+	{ 0x2c, "TxTS256_511", },
+	{ 0x2d, "TxTS512_1023", },
+	{ 0x2e, "TxTS1024_1518", },
+	{ 0x2f, "TxTS>1518", },
+	{ 0x30, "TxTrafficClassOverrun0", },
+	{ 0x31, "TxTrafficClassOverrun1", },
+	{ 0x32, "TxTrafficClassOverrun2", },
+	{ 0x33, "TxTrafficClassOverrun3", },
+	{ 0x34, "TxTrafficClassOverrun4", },
+	{ 0x35, "TxTrafficClassOverrun5", },
+	{ 0x36, "TxTrafficClassOverrun6", },
+	{ 0x37, "TxTrafficClassOverrun7", },
+	{ 0x38, "TxTrafficClass0", },
+	{ 0x39, "TxTrafficClass1", },
+	{ 0x3a, "TxTrafficClass2", },
+	{ 0x3b, "TxTrafficClass3", },
+	{ 0x3c, "TxTrafficClass4", },
+	{ 0x3d, "TxTrafficClass5", },
+	{ 0x3e, "TxTrafficClass6", },
+	{ 0x3f, "TxTrafficClass7", },
+};
+
+static u16 hellcreek_read(struct hellcreek *hellcreek, unsigned int offset)
+{
+	return readw(hellcreek->base + offset);
+}
+
+static u16 hellcreek_read_ctrl(struct hellcreek *hellcreek)
+{
+	return readw(hellcreek->base + HR_CTRL_C);
+}
+
+static u16 hellcreek_read_stat(struct hellcreek *hellcreek)
+{
+	return readw(hellcreek->base + HR_SWSTAT);
+}
+
+static void hellcreek_write(struct hellcreek *hellcreek, u16 data,
+			    unsigned int offset)
+{
+	writew(data, hellcreek->base + offset);
+}
+
+static void hellcreek_select_port(struct hellcreek *hellcreek, int port)
+{
+	u16 val = port << HR_PSEL_PTWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
+static void hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
+{
+	u16 val = prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
+static void hellcreek_select_counter(struct hellcreek *hellcreek, int counter)
+{
+	u16 val = counter << HR_CSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_CSEL);
+
+	/* Data sheet states to wait at least 20 internal clock cycles */
+	ndelay(200);
+}
+
+static void hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
+				  bool pvid)
+{
+	u16 val = 0;
+
+	/* Set pvid bit first */
+	if (pvid)
+		val |= HR_VIDCFG_PVID;
+	hellcreek_write(hellcreek, val, HR_VIDCFG);
+
+	/* Set vlan */
+	val |= vid << HR_VIDCFG_VID_SHIFT;
+	hellcreek_write(hellcreek, val, HR_VIDCFG);
+}
+
+static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	/* Wait up to 1ms, although 3 us should be enough */
+	return readx_poll_timeout(hellcreek_read_ctrl, hellcreek,
+				  val, val & HR_CTRL_C_READY,
+				  3, 1000);
+}
+
+static int hellcreek_wait_until_transitioned(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	return readx_poll_timeout_atomic(hellcreek_read_ctrl, hellcreek,
+					 val, !(val & HR_CTRL_C_TRANSITION),
+					 1, 1000);
+}
+
+static int hellcreek_wait_fdb_ready(struct hellcreek *hellcreek)
+{
+	u16 val;
+
+	return readx_poll_timeout_atomic(hellcreek_read_stat, hellcreek,
+					 val, !(val & HR_SWSTAT_BUSY),
+					 1, 1000);
+}
+
+static int hellcreek_detect(struct hellcreek *hellcreek)
+{
+	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
+	u8 tgd_maj, tgd_min;
+	u32 rel, date;
+
+	id	  = hellcreek_read(hellcreek, HR_MODID_C);
+	rel_low	  = hellcreek_read(hellcreek, HR_REL_L_C);
+	rel_high  = hellcreek_read(hellcreek, HR_REL_H_C);
+	date_low  = hellcreek_read(hellcreek, HR_BLD_L_C);
+	date_high = hellcreek_read(hellcreek, HR_BLD_H_C);
+	tgd_ver   = hellcreek_read(hellcreek, TR_TGDVER);
+
+	if (id != hellcreek->pdata->module_id)
+		return -ENODEV;
+
+	rel	= rel_low | (rel_high << 16);
+	date	= date_low | (date_high << 16);
+	tgd_maj = (tgd_ver & TR_TGDVER_REV_MAJ_MASK) >> TR_TGDVER_REV_MAJ_SHIFT;
+	tgd_min = (tgd_ver & TR_TGDVER_REV_MIN_MASK) >> TR_TGDVER_REV_MIN_SHIFT;
+
+	dev_info(hellcreek->dev, "Module ID=%02x Release=%04x Date=%04x TGD Version=%02x.%02x\n",
+		 id, rel, date, tgd_maj, tgd_min);
+
+	return 0;
+}
+
+static void hellcreek_feature_detect(struct hellcreek *hellcreek)
+{
+	u16 features;
+
+	features = hellcreek_read(hellcreek, HR_FEABITS0);
+
+	/* Currently we only detect the size of the FDB table */
+	hellcreek->fdb_entries = ((features & HR_FEABITS0_FDBBINS_MASK) >>
+			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
+
+	dev_info(hellcreek->dev, "Feature detect: FDB entries=%zu\n",
+		 hellcreek->fdb_entries);
+}
+
+static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_switch *ds,
+							int port,
+							enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_HELLCREEK;
+}
+
+static int hellcreek_port_enable(struct dsa_switch *ds, int port,
+				 struct phy_device *phy)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+	u16 val;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	dev_dbg(hellcreek->dev, "Enable port %d\n", port);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_select_port(hellcreek, port);
+	val = hellcreek_port->ptcfg;
+	val |= HR_PTCFG_ADMIN_EN;
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return 0;
+}
+
+static void hellcreek_port_disable(struct dsa_switch *ds, int port)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+	u16 val;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	dev_dbg(hellcreek->dev, "Disable port %d\n", port);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_select_port(hellcreek, port);
+	val = hellcreek_port->ptcfg;
+	val &= ~HR_PTCFG_ADMIN_EN;
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+static void hellcreek_get_strings(struct dsa_switch *ds, int port,
+				  u32 stringset, uint8_t *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
+		const struct hellcreek_counter *counter = &hellcreek_counter[i];
+
+		strlcpy(data + i * ETH_GSTRING_LEN,
+			counter->name, ETH_GSTRING_LEN);
+	}
+}
+
+static int hellcreek_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return ARRAY_SIZE(hellcreek_counter);
+}
+
+static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+	int i;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
+		const struct hellcreek_counter *counter = &hellcreek_counter[i];
+		u8 offset = counter->offset + port * 64;
+		u16 high, low;
+		u64 value = 0;
+
+		mutex_lock(&hellcreek->reg_lock);
+
+		hellcreek_select_counter(hellcreek, offset);
+
+		/* The registers are locked internally by selecting the
+		 * counter. So low and high can be read without reading high
+		 * again.
+		 */
+		high  = hellcreek_read(hellcreek, HR_CRDH);
+		low   = hellcreek_read(hellcreek, HR_CRDL);
+		value = (high << 16) | low;
+
+		hellcreek_port->counter_values[i] += value;
+		data[i] = hellcreek_port->counter_values[i];
+
+		mutex_unlock(&hellcreek->reg_lock);
+	}
+}
+
+static u16 hellcreek_private_vid(int port)
+{
+	return VLAN_N_VID - port + 1;
+}
+
+static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	int i;
+
+	dev_dbg(hellcreek->dev, "VLAN prepare for port %d\n", port);
+
+	/* Restriction: Make sure that nobody uses the "private" VLANs. These
+	 * VLANs are internally used by the driver to ensure port
+	 * separation. Thus, they cannot be used by someone else.
+	 */
+	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
+		const u16 restricted_vid = hellcreek_private_vid(i);
+		u16 vid;
+
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
+			if (vid == restricted_vid)
+				return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void hellcreek_select_vlan_params(struct hellcreek *hellcreek, int port,
+					 int *shift, int *mask)
+{
+	switch (port) {
+	case 0:
+		*shift = HR_VIDMBRCFG_P0MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P0MBR_MASK;
+		break;
+	case 1:
+		*shift = HR_VIDMBRCFG_P1MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P1MBR_MASK;
+		break;
+	case 2:
+		*shift = HR_VIDMBRCFG_P2MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P2MBR_MASK;
+		break;
+	case 3:
+		*shift = HR_VIDMBRCFG_P3MBR_SHIFT;
+		*mask  = HR_VIDMBRCFG_P3MBR_MASK;
+		break;
+	default:
+		*shift = *mask = 0;
+		dev_err(hellcreek->dev, "Unknown port %d selected!\n", port);
+	}
+}
+
+static void hellcreek_apply_vlan(struct hellcreek *hellcreek, int port, u16 vid,
+				 bool pvid, bool untagged)
+{
+	int shift, mask;
+	u16 val;
+
+	dev_dbg(hellcreek->dev, "Apply VLAN: port=%d vid=%u pvid=%d untagged=%d",
+		port, vid, pvid, untagged);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_select_port(hellcreek, port);
+	hellcreek_select_vlan(hellcreek, vid, pvid);
+
+	/* Setup port vlan membership */
+	hellcreek_select_vlan_params(hellcreek, port, &shift, &mask);
+	val = hellcreek->vidmbrcfg[vid];
+	val &= ~mask;
+	if (untagged)
+		val |= HELLCREEK_VLAN_UNTAGGED_MEMBER << shift;
+	else
+		val |= HELLCREEK_VLAN_TAGGED_MEMBER << shift;
+
+	hellcreek_write(hellcreek, val, HR_VIDMBRCFG);
+	hellcreek->vidmbrcfg[vid] = val;
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+static void hellcreek_unapply_vlan(struct hellcreek *hellcreek, int port,
+				   u16 vid)
+{
+	int shift, mask;
+	u16 val;
+
+	dev_dbg(hellcreek->dev, "Unapply VLAN: port=%d vid=%u\n", port, vid);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_select_vlan(hellcreek, vid, 0);
+
+	/* Setup port vlan membership */
+	hellcreek_select_vlan_params(hellcreek, port, &shift, &mask);
+	val = hellcreek->vidmbrcfg[vid];
+	val &= ~mask;
+	val |= HELLCREEK_VLAN_NO_MEMBER << shift;
+
+	hellcreek_write(hellcreek, val, HR_VIDMBRCFG);
+	hellcreek->vidmbrcfg[vid] = val;
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct hellcreek *hellcreek = ds->priv;
+	u16 vid;
+
+	dev_dbg(hellcreek->dev, "Add VLANs (%d -- %d) on port %d, %s, %s\n",
+		vlan->vid_begin, vlan->vid_end, port,
+		untagged ? "untagged" : "tagged",
+		pvid ? "PVID" : "no PVID");
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
+		hellcreek_apply_vlan(hellcreek, port, vid, pvid, untagged);
+}
+
+static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	u16 vid;
+
+	dev_dbg(hellcreek->dev, "Remove VLANs (%d -- %d) on port %d\n",
+		vlan->vid_begin, vlan->vid_end, port);
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
+		hellcreek_unapply_vlan(hellcreek, port, vid);
+
+	return 0;
+}
+
+static void hellcreek_port_stp_state_set(struct dsa_switch *ds, int port,
+					 u8 state)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+	const char *new_state;
+	u16 val;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_port = &hellcreek->ports[port];
+	val = hellcreek_port->ptcfg;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		new_state = "DISABLED";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_BLOCKING:
+		new_state = "BLOCKING";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_LISTENING:
+		new_state = "LISTENING";
+		val |= HR_PTCFG_BLOCKED;
+		val &= ~HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_LEARNING:
+		new_state = "LEARNING";
+		val |= HR_PTCFG_BLOCKED;
+		val |= HR_PTCFG_LEARNING_EN;
+		break;
+	case BR_STATE_FORWARDING:
+		new_state = "FORWARDING";
+		val &= ~HR_PTCFG_BLOCKED;
+		val |= HR_PTCFG_LEARNING_EN;
+		break;
+	default:
+		new_state = "UNKNOWN";
+	}
+
+	hellcreek_select_port(hellcreek, port);
+	hellcreek_write(hellcreek, val, HR_PTCFG);
+	hellcreek_port->ptcfg = val;
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	dev_dbg(hellcreek->dev, "Configured STP state for port %d: %s\n",
+		port, new_state);
+}
+
+static void hellcreek_setup_ingressflt(struct hellcreek *hellcreek, int port,
+				       bool enable)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	u16 ptcfg;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	ptcfg = hellcreek_port->ptcfg;
+
+	if (enable)
+		ptcfg |= HR_PTCFG_INGRESSFLT;
+	else
+		ptcfg &= ~HR_PTCFG_INGRESSFLT;
+
+	hellcreek_select_port(hellcreek, port);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+	hellcreek_port->ptcfg = ptcfg;
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+static void hellcreek_setup_vlan_awareness(struct hellcreek *hellcreek,
+					   bool enable)
+{
+	u16 swcfg;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	swcfg = hellcreek->swcfg;
+
+	if (enable)
+		swcfg |= HR_SWCFG_VLAN_UNAWARE;
+	else
+		swcfg &= ~HR_SWCFG_VLAN_UNAWARE;
+
+	hellcreek_write(hellcreek, swcfg, HR_SWCFG);
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+/* Default setup for DSA: VLAN <X>: CPU and Port <X> egress untagged. */
+static void hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
+					    bool enabled)
+{
+	const u16 vid = hellcreek_private_vid(port);
+	int upstream = dsa_upstream_port(ds, port);
+	struct hellcreek *hellcreek = ds->priv;
+
+	/* Apply vid to port as egress untagged and port vlan id */
+	if (enabled)
+		hellcreek_apply_vlan(hellcreek, port, vid, true, true);
+	else
+		hellcreek_unapply_vlan(hellcreek, port, vid);
+
+	/* Apply vid to cpu port as well */
+	if (enabled)
+		hellcreek_apply_vlan(hellcreek, upstream, vid, false, true);
+	else
+		hellcreek_unapply_vlan(hellcreek, upstream, vid);
+}
+
+static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
+				      struct net_device *br)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
+
+	/* When joining a vlan_filtering bridge, keep the switch VLAN aware */
+	if (!ds->vlan_filtering)
+		hellcreek_setup_vlan_awareness(hellcreek, false);
+
+	/* Drop private vlans */
+	hellcreek_setup_vlan_membership(ds, port, false);
+
+	return 0;
+}
+
+static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
+					struct net_device *br)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	dev_dbg(hellcreek->dev, "Port %d leaves a bridge\n", port);
+
+	/* Enable VLAN awareness */
+	hellcreek_setup_vlan_awareness(hellcreek, true);
+
+	/* Enable private vlans */
+	hellcreek_setup_vlan_membership(ds, port, true);
+}
+
+static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
+			       const struct hellcreek_fdb_entry *entry)
+{
+	u16 meta = 0;
+
+	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
+		"OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
+		entry->is_obt, entry->reprio_en, entry->reprio_tc);
+
+	/* Add mac address */
+	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
+	hellcreek_write(hellcreek, entry->mac[3] | (entry->mac[2] << 8), HR_FDBWDM);
+	hellcreek_write(hellcreek, entry->mac[5] | (entry->mac[4] << 8), HR_FDBWDL);
+
+	/* Meta data */
+	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
+	if (entry->is_obt)
+		meta |= HR_FDBWRM0_OBT;
+	if (entry->reprio_en) {
+		meta |= HR_FDBWRM0_REPRIO_EN;
+		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
+	}
+	hellcreek_write(hellcreek, meta, HR_FDBWRM0);
+
+	/* Commit */
+	hellcreek_write(hellcreek, 0x00, HR_FDBWRCMD);
+
+	/* Wait until done */
+	return hellcreek_wait_fdb_ready(hellcreek);
+}
+
+static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
+			       const struct hellcreek_fdb_entry *entry)
+{
+	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=%pM!\n", entry->mac);
+
+	/* Delete by matching idx */
+	hellcreek_write(hellcreek, entry->idx | HR_FDBWRCMD_FDBDEL, HR_FDBWRCMD);
+
+	/* Wait until done */
+	return hellcreek_wait_fdb_ready(hellcreek);
+}
+
+/* Retrieve the index of a FDB entry by mac address. Currently we search through
+ * the complete table in hardware. If that's too slow, we might have to cache
+ * the complete FDB table in software.
+ */
+static int hellcreek_fdb_get(struct hellcreek *hellcreek,
+			     const unsigned char *dest,
+			     struct hellcreek_fdb_entry *entry)
+{
+	size_t i;
+
+	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
+	 * should reset the internal pointer. But, that doesn't work. The vendor
+	 * suggested a subsequent write as workaround. Same for HR_FDBRDH below.
+	 */
+	hellcreek_read(hellcreek, HR_FDBMAX);
+	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
+
+	/* We have to read the complete table, because the switch/driver might
+	 * enter new entries anywhere.
+	 */
+	for (i = 0; i < hellcreek->fdb_entries; ++i) {
+		unsigned char addr[ETH_ALEN];
+		u16 meta, mac;
+
+		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
+		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
+		addr[5] = mac & 0xff;
+		addr[4] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
+		addr[3] = mac & 0xff;
+		addr[2] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
+		addr[1] = mac & 0xff;
+		addr[0] = (mac & 0xff00) >> 8;
+
+		/* Force next entry */
+		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
+
+		if (memcmp(addr, dest, ETH_ALEN))
+			continue;
+
+		/* Match found */
+		entry->idx	    = i;
+		entry->portmask	    = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
+			HR_FDBMDRD_PORTMASK_SHIFT;
+		entry->age	    = (meta & HR_FDBMDRD_AGE_MASK) >>
+			HR_FDBMDRD_AGE_SHIFT;
+		entry->is_obt	    = !!(meta & HR_FDBMDRD_OBT);
+		entry->pass_blocked = !!(meta & HR_FDBMDRD_PASS_BLOCKED);
+		entry->is_static    = !!(meta & HR_FDBMDRD_STATIC);
+		entry->reprio_tc    = (meta & HR_FDBMDRD_REPRIO_TC_MASK) >>
+			HR_FDBMDRD_REPRIO_TC_SHIFT;
+		entry->reprio_en    = !!(meta & HR_FDBMDRD_REPRIO_EN);
+		memcpy(entry->mac, addr, sizeof(addr));
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
+			     const unsigned char *addr, u16 vid)
+{
+	struct hellcreek_fdb_entry entry = { 0 };
+	struct hellcreek *hellcreek = ds->priv;
+	int ret;
+
+	dev_dbg(hellcreek->dev, "Add FDB entry for MAC=%pM\n", addr);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	ret = hellcreek_fdb_get(hellcreek, addr, &entry);
+	if (ret) {
+		/* Not found */
+		memcpy(entry.mac, addr, sizeof(entry.mac));
+		entry.portmask = BIT(port);
+
+		ret = __hellcreek_fdb_add(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+			goto out;
+		}
+	} else {
+		/* Found */
+		ret = __hellcreek_fdb_del(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to delete FDB entry!\n");
+			goto out;
+		}
+
+		entry.portmask |= BIT(port);
+
+		ret = __hellcreek_fdb_add(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return ret;
+}
+
+static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
+			     const unsigned char *addr, u16 vid)
+{
+	struct hellcreek_fdb_entry entry = { 0 };
+	struct hellcreek *hellcreek = ds->priv;
+	int ret;
+
+	dev_dbg(hellcreek->dev, "Delete FDB entry for MAC=%pM\n", addr);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	ret = hellcreek_fdb_get(hellcreek, addr, &entry);
+	if (ret) {
+		/* Not found */
+		dev_err(hellcreek->dev, "FDB entry for deletion not found!\n");
+	} else {
+		/* Found */
+		ret = __hellcreek_fdb_del(hellcreek, &entry);
+		if (ret) {
+			dev_err(hellcreek->dev, "Failed to delete FDB entry!\n");
+			goto out;
+		}
+
+		entry.portmask &= ~BIT(port);
+
+		if (entry.portmask != 0x00) {
+			ret = __hellcreek_fdb_add(hellcreek, &entry);
+			if (ret) {
+				dev_err(hellcreek->dev, "Failed to add FDB entry!\n");
+				goto out;
+			}
+		}
+	}
+
+out:
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return ret;
+}
+
+static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
+			      dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	u16 entries;
+	size_t i;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
+	 * should reset the internal pointer. But, that doesn't work. The vendor
+	 * suggested a subsequent write as workaround. Same for HR_FDBRDH below.
+	 */
+	entries = hellcreek_read(hellcreek, HR_FDBMAX);
+	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
+
+	dev_dbg(hellcreek->dev, "FDB dump for port %d, entries=%d!\n", port, entries);
+
+	/* Read table */
+	for (i = 0; i < hellcreek->fdb_entries; ++i) {
+		unsigned char null_addr[ETH_ALEN] = { 0 };
+		struct hellcreek_fdb_entry entry = { 0 };
+		u16 meta, mac;
+
+		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
+		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
+		entry.mac[5] = mac & 0xff;
+		entry.mac[4] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
+		entry.mac[3] = mac & 0xff;
+		entry.mac[2] = (mac & 0xff00) >> 8;
+		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
+		entry.mac[1] = mac & 0xff;
+		entry.mac[0] = (mac & 0xff00) >> 8;
+
+		/* Force next entry */
+		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
+
+		/* Check valid */
+		if (!memcmp(entry.mac, null_addr, ETH_ALEN))
+			continue;
+
+		entry.portmask	= (meta & HR_FDBMDRD_PORTMASK_MASK) >>
+			HR_FDBMDRD_PORTMASK_SHIFT;
+		entry.is_static	= !!(meta & HR_FDBMDRD_STATIC);
+
+		/* Check port mask */
+		if (!(entry.portmask & BIT(port)))
+			continue;
+
+		cb(entry.mac, 0, entry.is_static, data);
+	}
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return 0;
+}
+
+static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
+				    bool vlan_filtering,
+				    struct switchdev_trans *trans)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	dev_dbg(hellcreek->dev, "%s VLAN filtering on port %d\n",
+		vlan_filtering ? "Enable" : "Disable", port);
+
+	/* Configure port to drop packages with not known vids */
+	hellcreek_setup_ingressflt(hellcreek, port, vlan_filtering);
+
+	/* Enable VLAN awareness on the switch. This save due to
+	 * ds->vlan_filtering_is_global.
+	 */
+	hellcreek_setup_vlan_awareness(hellcreek, vlan_filtering);
+
+	return 0;
+}
+
+static int hellcreek_enable_ip_core(struct hellcreek *hellcreek)
+{
+	int ret;
+	u16 val;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	val = hellcreek_read(hellcreek, HR_CTRL_C);
+	val |= HR_CTRL_C_ENABLE;
+	hellcreek_write(hellcreek, val, HR_CTRL_C);
+	ret = hellcreek_wait_until_transitioned(hellcreek);
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return ret;
+}
+
+static void hellcreek_setup_cpu_and_tunnel_port(struct hellcreek *hellcreek)
+{
+	struct hellcreek_port *tunnel_port = &hellcreek->ports[TUNNEL_PORT];
+	struct hellcreek_port *cpu_port = &hellcreek->ports[CPU_PORT];
+	u16 ptcfg = 0;
+
+	ptcfg |= HR_PTCFG_LEARNING_EN | HR_PTCFG_ADMIN_EN;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	hellcreek_select_port(hellcreek, CPU_PORT);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+
+	hellcreek_select_port(hellcreek, TUNNEL_PORT);
+	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
+
+	cpu_port->ptcfg	   = ptcfg;
+	tunnel_port->ptcfg = ptcfg;
+
+	mutex_unlock(&hellcreek->reg_lock);
+}
+
+static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
+{
+	int i;
+
+	/* The switch has multiple egress queues per port. The queue is selected
+	 * via the PCP field in the VLAN header. The switch internally deals
+	 * with traffic classes instead of PCP values and this mapping is
+	 * configurable.
+	 *
+	 * The default mapping is (PCP - TC):
+	 *  7 - 7
+	 *  6 - 6
+	 *  5 - 5
+	 *  4 - 4
+	 *  3 - 3
+	 *  2 - 1
+	 *  1 - 0
+	 *  0 - 2
+	 *
+	 * The default should be an identity mapping.
+	 */
+
+	for (i = 0; i < 8; ++i) {
+		mutex_lock(&hellcreek->reg_lock);
+
+		hellcreek_select_prio(hellcreek, i);
+		hellcreek_write(hellcreek,
+				i << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
+				HR_PRTCCFG);
+
+		mutex_unlock(&hellcreek->reg_lock);
+	}
+}
+
+static int hellcreek_setup(struct dsa_switch *ds)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	u16 swcfg = 0;
+	int ret, i;
+
+	dev_dbg(hellcreek->dev, "Set up the switch\n");
+
+	/* Let's go */
+	ret = hellcreek_enable_ip_core(hellcreek);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to enable IP core!\n");
+		return ret;
+	}
+
+	/* Enable CPU/Tunnel ports */
+	hellcreek_setup_cpu_and_tunnel_port(hellcreek);
+
+	/* Switch config: Keep defaults, enable FDB aging and learning and tag
+	 * each frame from/to cpu port for DSA tagging.  Also enable the length
+	 * aware shaping mode. This eliminates the need for Qbv guard bands.
+	 */
+	swcfg |= HR_SWCFG_FDBAGE_EN |
+		HR_SWCFG_FDBLRN_EN  |
+		HR_SWCFG_ALWAYS_OBT |
+		(HR_SWCFG_LAS_ON << HR_SWCFG_LAS_MODE_SHIFT);
+	hellcreek->swcfg = swcfg;
+	hellcreek_write(hellcreek, swcfg, HR_SWCFG);
+
+	/* Initial vlan membership to reflect port separation */
+	for (i = 0; i < ds->num_ports; ++i) {
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		hellcreek_setup_vlan_membership(ds, i, true);
+	}
+
+	/* Configure PCP <-> TC mapping */
+	hellcreek_setup_tc_identity_mapping(hellcreek);
+
+	/* Allow VLAN configurations while not filtering which is the default
+	 * for new DSA drivers.
+	 */
+	ds->configure_vlan_while_not_filtering = true;
+
+	/* The VLAN awareness is a global switch setting. Therefore, mixed vlan
+	 * filtering setups are not supported.
+	 */
+	ds->vlan_filtering_is_global = true;
+
+	return 0;
+}
+
+static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
+				       unsigned long *supported,
+				       struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	struct hellcreek *hellcreek = ds->priv;
+
+	dev_dbg(hellcreek->dev, "Phylink validate for port %d\n", port);
+
+	/* The MAC settings are a hardware configuration option and cannot be
+	 * changed at run time or by strapping. Therefore the attached PHYs
+	 * should be programmed to only advertise settings which are supported
+	 * by the hardware.
+	 */
+	if (hellcreek->pdata->is_100_mbits)
+		phylink_set(mask, 100baseT_Full);
+	else
+		phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int
+hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
+			      struct netdev_notifier_changeupper_info *info)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	bool used = true;
+	int ret = -EBUSY;
+	u16 vid;
+	int i;
+
+	dev_dbg(hellcreek->dev, "Pre change upper for port %d\n", port);
+
+	/*
+	 * Deny VLAN devices on top of lan ports with the same VLAN ids, because
+	 * it breaks the port separation due to the private VLANs. Example:
+	 *
+	 * lan0.100 *and* lan1.100 cannot be used in parallel. However, lan0.99
+	 * and lan1.100 works.
+	 */
+
+	if (!is_vlan_dev(info->upper_dev))
+		return 0;
+
+	vid = vlan_dev_vlan_id(info->upper_dev);
+
+	/* For all ports, check bitmaps */
+	mutex_lock(&hellcreek->vlan_lock);
+	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		if (port == i)
+			continue;
+
+		used = used && test_bit(vid, hellcreek->ports[i].vlan_dev_bitmap);
+	}
+
+	if (used)
+		goto out;
+
+	/* Update bitmap */
+	set_bit(vid, hellcreek->ports[port].vlan_dev_bitmap);
+
+	ret = 0;
+
+out:
+	mutex_unlock(&hellcreek->vlan_lock);
+
+	return ret;
+}
+
+static const struct dsa_switch_ops hellcreek_ds_ops = {
+	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
+	.get_sset_count	     = hellcreek_get_sset_count,
+	.get_strings	     = hellcreek_get_strings,
+	.get_tag_protocol    = hellcreek_get_tag_protocol,
+	.phylink_validate    = hellcreek_phylink_validate,
+	.port_bridge_join    = hellcreek_port_bridge_join,
+	.port_bridge_leave   = hellcreek_port_bridge_leave,
+	.port_disable	     = hellcreek_port_disable,
+	.port_enable	     = hellcreek_port_enable,
+	.port_fdb_add	     = hellcreek_fdb_add,
+	.port_fdb_del	     = hellcreek_fdb_del,
+	.port_fdb_dump	     = hellcreek_fdb_dump,
+	.port_prechangeupper = hellcreek_port_prechangeupper,
+	.port_stp_state_set  = hellcreek_port_stp_state_set,
+	.port_vlan_add	     = hellcreek_vlan_add,
+	.port_vlan_del	     = hellcreek_vlan_del,
+	.port_vlan_filtering = hellcreek_vlan_filtering,
+	.port_vlan_prepare   = hellcreek_vlan_prepare,
+	.setup		     = hellcreek_setup,
+};
+
+static int hellcreek_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct hellcreek *hellcreek;
+	struct resource *res;
+	int ret, i;
+
+	hellcreek = devm_kzalloc(dev, sizeof(*hellcreek), GFP_KERNEL);
+	if (!hellcreek)
+		return -ENOMEM;
+
+	hellcreek->vidmbrcfg = devm_kcalloc(dev, VLAN_N_VID,
+					    sizeof(*hellcreek->vidmbrcfg),
+					    GFP_KERNEL);
+	if (!hellcreek->vidmbrcfg)
+		return -ENOMEM;
+
+	hellcreek->pdata = of_device_get_match_data(dev);
+
+	hellcreek->ports = devm_kcalloc(dev, hellcreek->pdata->num_ports,
+					sizeof(*hellcreek->ports),
+					GFP_KERNEL);
+	if (!hellcreek->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
+		struct hellcreek_port *port = &hellcreek->ports[i];
+
+		port->counter_values =
+			devm_kcalloc(dev,
+				     ARRAY_SIZE(hellcreek_counter),
+				     sizeof(*port->counter_values),
+				     GFP_KERNEL);
+		if (!port->counter_values)
+			return -ENOMEM;
+
+		port->vlan_dev_bitmap =
+			devm_kcalloc(dev,
+				     BITS_TO_LONGS(VLAN_N_VID),
+				     sizeof(unsigned long),
+				     GFP_KERNEL);
+		if (!port->vlan_dev_bitmap)
+			return -ENOMEM;
+
+		port->hellcreek	= hellcreek;
+		port->port	= i;
+	}
+
+	mutex_init(&hellcreek->reg_lock);
+	mutex_init(&hellcreek->vlan_lock);
+
+	hellcreek->dev = dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tsn");
+	if (!res) {
+		dev_err(dev, "No memory region provided!\n");
+		return -ENODEV;
+	}
+
+	hellcreek->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hellcreek->base)) {
+		dev_err(dev, "No memory available!\n");
+		return PTR_ERR(hellcreek->base);
+	}
+
+	ret = hellcreek_detect(hellcreek);
+	if (ret) {
+		dev_err(dev, "No (known) chip found!\n");
+		return ret;
+	}
+
+	ret = hellcreek_wait_until_ready(hellcreek);
+	if (ret) {
+		dev_err(dev, "Switch didn't become ready!\n");
+		return ret;
+	}
+
+	hellcreek_feature_detect(hellcreek);
+
+	hellcreek->ds = devm_kzalloc(dev, sizeof(*hellcreek->ds), GFP_KERNEL);
+	if (!hellcreek->ds)
+		return -ENOMEM;
+
+	hellcreek->ds->dev	     = dev;
+	hellcreek->ds->priv	     = hellcreek;
+	hellcreek->ds->ops	     = &hellcreek_ds_ops;
+	hellcreek->ds->num_ports     = hellcreek->pdata->num_ports;
+	hellcreek->ds->num_tx_queues = HELLCREEK_NUM_EGRESS_QUEUES;
+
+	ret = dsa_register_switch(hellcreek->ds);
+	if (ret) {
+		dev_err(dev, "Unable to register switch\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, hellcreek);
+
+	return 0;
+}
+
+static int hellcreek_remove(struct platform_device *pdev)
+{
+	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
+
+	dsa_unregister_switch(hellcreek->ds);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct hellcreek_platform_data de1soc_r1_pdata = {
+	.num_ports	 = 4,
+	.is_100_mbits	 = 1,
+	.qbv_support	 = 1,
+	.qbv_on_cpu_port = 1,
+	.qbu_support	 = 0,
+	.module_id	 = 0x4c30,
+};
+
+static const struct of_device_id hellcreek_of_match[] = {
+	{
+		.compatible = "hirschmann,hellcreek-de1soc-r1",
+		.data	    = &de1soc_r1_pdata,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, hellcreek_of_match);
+
+static struct platform_driver hellcreek_driver = {
+	.probe	= hellcreek_probe,
+	.remove = hellcreek_remove,
+	.driver = {
+		.name = "hellcreek",
+		.of_match_table = hellcreek_of_match,
+	},
+};
+module_platform_driver(hellcreek_driver);
+
+MODULE_AUTHOR("Kurt Kanzenbach <kurt@linutronix.de>");
+MODULE_DESCRIPTION("Hirschmann Hellcreek driver");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
new file mode 100644
index 000000000000..762bf9734630
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -0,0 +1,249 @@
+/* SPDX-License-Identifier: (GPL-2.0 or MIT) */
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#ifndef _HELLCREEK_H_
+#define _HELLCREEK_H_
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/platform_data/hirschmann-hellcreek.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+#include <net/dsa.h>
+
+/* Ports:
+ *  - 0: CPU
+ *  - 1: Tunnel
+ *  - 2: TSN front port 1
+ *  - 3: TSN front port 2
+ *  - ...
+ */
+#define CPU_PORT			0
+#define TUNNEL_PORT			1
+
+#define HELLCREEK_VLAN_NO_MEMBER	0x0
+#define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
+#define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
+#define HELLCREEK_NUM_EGRESS_QUEUES	8
+
+/* Register definitions */
+#define HR_MODID_C			(0 * 2)
+#define HR_REL_L_C			(1 * 2)
+#define HR_REL_H_C			(2 * 2)
+#define HR_BLD_L_C			(3 * 2)
+#define HR_BLD_H_C			(4 * 2)
+#define HR_CTRL_C			(5 * 2)
+#define HR_CTRL_C_READY			BIT(14)
+#define HR_CTRL_C_TRANSITION		BIT(13)
+#define HR_CTRL_C_ENABLE		BIT(0)
+
+#define HR_PSEL				(0xa6 * 2)
+#define HR_PSEL_PTWSEL_SHIFT		4
+#define HR_PSEL_PTWSEL_MASK		GENMASK(5, 4)
+#define HR_PSEL_PRTCWSEL_SHIFT		0
+#define HR_PSEL_PRTCWSEL_MASK		GENMASK(2, 0)
+
+#define HR_PTCFG			(0xa7 * 2)
+#define HR_PTCFG_MLIMIT_EN		BIT(13)
+#define HR_PTCFG_UMC_FLT		BIT(10)
+#define HR_PTCFG_UUC_FLT		BIT(9)
+#define HR_PTCFG_UNTRUST		BIT(8)
+#define HR_PTCFG_TAG_REQUIRED		BIT(7)
+#define HR_PTCFG_PPRIO_SHIFT		4
+#define HR_PTCFG_PPRIO_MASK		GENMASK(6, 4)
+#define HR_PTCFG_INGRESSFLT		BIT(3)
+#define HR_PTCFG_BLOCKED		BIT(2)
+#define HR_PTCFG_LEARNING_EN		BIT(1)
+#define HR_PTCFG_ADMIN_EN		BIT(0)
+
+#define HR_PRTCCFG			(0xa8 * 2)
+#define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
+#define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
+
+#define HR_CSEL				(0x8d * 2)
+#define HR_CSEL_SHIFT			0
+#define HR_CSEL_MASK			GENMASK(7, 0)
+#define HR_CRDL				(0x8e * 2)
+#define HR_CRDH				(0x8f * 2)
+
+#define HR_SWTRC_CFG			(0x90 * 2)
+#define HR_SWTRC0			(0x91 * 2)
+#define HR_SWTRC1			(0x92 * 2)
+#define HR_PFREE			(0x93 * 2)
+#define HR_MFREE			(0x94 * 2)
+
+#define HR_FDBAGE			(0x97 * 2)
+#define HR_FDBMAX			(0x98 * 2)
+#define HR_FDBRDL			(0x99 * 2)
+#define HR_FDBRDM			(0x9a * 2)
+#define HR_FDBRDH			(0x9b * 2)
+
+#define HR_FDBMDRD			(0x9c * 2)
+#define HR_FDBMDRD_PORTMASK_SHIFT	0
+#define HR_FDBMDRD_PORTMASK_MASK	GENMASK(3, 0)
+#define HR_FDBMDRD_AGE_SHIFT		4
+#define HR_FDBMDRD_AGE_MASK		GENMASK(7, 4)
+#define HR_FDBMDRD_OBT			BIT(8)
+#define HR_FDBMDRD_PASS_BLOCKED		BIT(9)
+#define HR_FDBMDRD_STATIC		BIT(11)
+#define HR_FDBMDRD_REPRIO_TC_SHIFT	12
+#define HR_FDBMDRD_REPRIO_TC_MASK	GENMASK(14, 12)
+#define HR_FDBMDRD_REPRIO_EN		BIT(15)
+
+#define HR_FDBWDL			(0x9d * 2)
+#define HR_FDBWDM			(0x9e * 2)
+#define HR_FDBWDH			(0x9f * 2)
+#define HR_FDBWRM0			(0xa0 * 2)
+#define HR_FDBWRM0_PORTMASK_SHIFT	0
+#define HR_FDBWRM0_PORTMASK_MASK	GENMASK(3, 0)
+#define HR_FDBWRM0_OBT			BIT(8)
+#define HR_FDBWRM0_PASS_BLOCKED		BIT(9)
+#define HR_FDBWRM0_REPRIO_TC_SHIFT	12
+#define HR_FDBWRM0_REPRIO_TC_MASK	GENMASK(14, 12)
+#define HR_FDBWRM0_REPRIO_EN		BIT(15)
+#define HR_FDBWRM1			(0xa1 * 2)
+
+#define HR_FDBWRCMD			(0xa2 * 2)
+#define HR_FDBWRCMD_FDBDEL		BIT(9)
+
+#define HR_SWCFG			(0xa3 * 2)
+#define HR_SWCFG_GM_STATEMD		BIT(15)
+#define HR_SWCFG_LAS_MODE_SHIFT		12
+#define HR_SWCFG_LAS_MODE_MASK		GENMASK(13, 12)
+#define HR_SWCFG_LAS_OFF		(0x00)
+#define HR_SWCFG_LAS_ON			(0x01)
+#define HR_SWCFG_LAS_STATIC		(0x10)
+#define HR_SWCFG_CT_EN			BIT(11)
+#define HR_SWCFG_VLAN_UNAWARE		BIT(10)
+#define HR_SWCFG_ALWAYS_OBT		BIT(9)
+#define HR_SWCFG_FDBAGE_EN		BIT(5)
+#define HR_SWCFG_FDBLRN_EN		BIT(4)
+
+#define HR_SWSTAT			(0xa4 * 2)
+#define HR_SWSTAT_FAIL			BIT(4)
+#define HR_SWSTAT_BUSY			BIT(0)
+
+#define HR_SWCMD			(0xa5 * 2)
+#define HW_SWCMD_FLUSH			BIT(0)
+
+#define HR_VIDCFG			(0xaa * 2)
+#define HR_VIDCFG_VID_SHIFT		0
+#define HR_VIDCFG_VID_MASK		GENMASK(11, 0)
+#define HR_VIDCFG_PVID			BIT(12)
+
+#define HR_VIDMBRCFG			(0xab * 2)
+#define HR_VIDMBRCFG_P0MBR_SHIFT	0
+#define HR_VIDMBRCFG_P0MBR_MASK		GENMASK(1, 0)
+#define HR_VIDMBRCFG_P1MBR_SHIFT	2
+#define HR_VIDMBRCFG_P1MBR_MASK		GENMASK(3, 2)
+#define HR_VIDMBRCFG_P2MBR_SHIFT	4
+#define HR_VIDMBRCFG_P2MBR_MASK		GENMASK(5, 4)
+#define HR_VIDMBRCFG_P3MBR_SHIFT	6
+#define HR_VIDMBRCFG_P3MBR_MASK		GENMASK(7, 6)
+
+#define HR_FEABITS0			(0xac * 2)
+#define HR_FEABITS0_FDBBINS_SHIFT	4
+#define HR_FEABITS0_FDBBINS_MASK	GENMASK(7, 4)
+#define HR_FEABITS0_PCNT_SHIFT		8
+#define HR_FEABITS0_PCNT_MASK		GENMASK(11, 8)
+#define HR_FEABITS0_MCNT_SHIFT		12
+#define HR_FEABITS0_MCNT_MASK		GENMASK(15, 12)
+
+#define TR_QTRACK			(0xb1 * 2)
+#define TR_TGDVER			(0xb3 * 2)
+#define TR_TGDVER_REV_MIN_MASK		GENMASK(7, 0)
+#define TR_TGDVER_REV_MIN_SHIFT		0
+#define TR_TGDVER_REV_MAJ_MASK		GENMASK(15, 8)
+#define TR_TGDVER_REV_MAJ_SHIFT		8
+#define TR_TGDSEL			(0xb4 * 2)
+#define TR_TGDSEL_TDGSEL_MASK		GENMASK(1, 0)
+#define TR_TGDSEL_TDGSEL_SHIFT		0
+#define TR_TGDCTRL			(0xb5 * 2)
+#define TR_TGDCTRL_GATE_EN		BIT(0)
+#define TR_TGDCTRL_CYC_SNAP		BIT(4)
+#define TR_TGDCTRL_SNAP_EST		BIT(5)
+#define TR_TGDCTRL_ADMINGATESTATES_MASK	GENMASK(15, 8)
+#define TR_TGDCTRL_ADMINGATESTATES_SHIFT	8
+#define TR_TGDSTAT0			(0xb6 * 2)
+#define TR_TGDSTAT1			(0xb7 * 2)
+#define TR_ESTWRL			(0xb8 * 2)
+#define TR_ESTWRH			(0xb9 * 2)
+#define TR_ESTCMD			(0xba * 2)
+#define TR_ESTCMD_ESTSEC_MASK		GENMASK(2, 0)
+#define TR_ESTCMD_ESTSEC_SHIFT		0
+#define TR_ESTCMD_ESTARM		BIT(4)
+#define TR_ESTCMD_ESTSWCFG		BIT(5)
+#define TR_EETWRL			(0xbb * 2)
+#define TR_EETWRH			(0xbc * 2)
+#define TR_EETCMD			(0xbd * 2)
+#define TR_EETCMD_EETSEC_MASK		GEMASK(2, 0)
+#define TR_EETCMD_EETSEC_SHIFT		0
+#define TR_EETCMD_EETARM		BIT(4)
+#define TR_CTWRL			(0xbe * 2)
+#define TR_CTWRH			(0xbf * 2)
+#define TR_LCNSL			(0xc1 * 2)
+#define TR_LCNSH			(0xc2 * 2)
+#define TR_LCS				(0xc3 * 2)
+#define TR_GCLDAT			(0xc4 * 2)
+#define TR_GCLDAT_GCLWRGATES_MASK	GENMASK(7, 0)
+#define TR_GCLDAT_GCLWRGATES_SHIFT	0
+#define TR_GCLDAT_GCLWRLAST		BIT(8)
+#define TR_GCLDAT_GCLOVRI		BIT(9)
+#define TR_GCLTIL			(0xc5 * 2)
+#define TR_GCLTIH			(0xc6 * 2)
+#define TR_GCLCMD			(0xc7 * 2)
+#define TR_GCLCMD_GCLWRADR_MASK		GENMASK(7, 0)
+#define TR_GCLCMD_GCLWRADR_SHIFT	0
+#define TR_GCLCMD_INIT_GATE_STATES_MASK	GENMASK(15, 8)
+#define TR_GCLCMD_INIT_GATE_STATES_SHIFT	8
+
+struct hellcreek_counter {
+	u8 offset;
+	const char *name;
+};
+
+struct hellcreek;
+
+struct hellcreek_port {
+	struct hellcreek *hellcreek;
+	unsigned long *vlan_dev_bitmap;
+	int port;
+	u16 ptcfg;		/* ptcfg shadow */
+	u64 *counter_values;
+};
+
+struct hellcreek_fdb_entry {
+	size_t idx;
+	unsigned char mac[ETH_ALEN];
+	u8 portmask;
+	u8 age;
+	u8 is_obt;
+	u8 pass_blocked;
+	u8 is_static;
+	u8 reprio_tc;
+	u8 reprio_en;
+};
+
+struct hellcreek {
+	const struct hellcreek_platform_data *pdata;
+	struct device *dev;
+	struct dsa_switch *ds;
+	struct hellcreek_port *ports;
+	struct mutex reg_lock;	/* Switch IP register lock */
+	struct mutex vlan_lock;	/* VLAN bitmaps lock */
+	void __iomem *base;
+	u16 swcfg;		/* swcfg shadow */
+	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
+	size_t fdb_entries;
+};
+
+#endif /* _HELLCREEK_H_ */
diff --git a/include/linux/platform_data/hirschmann-hellcreek.h b/include/linux/platform_data/hirschmann-hellcreek.h
new file mode 100644
index 000000000000..388846766bb2
--- /dev/null
+++ b/include/linux/platform_data/hirschmann-hellcreek.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: (GPL-2.0 or MIT) */
+/*
+ * Hirschmann Hellcreek TSN switch platform data.
+ *
+ * Copyright (C) 2020 Linutronix GmbH
+ * Author Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#ifndef _HIRSCHMANN_HELLCREEK_H_
+#define _HIRSCHMANN_HELLCREEK_H_
+
+#include <linux/types.h>
+
+struct hellcreek_platform_data {
+	int num_ports;		/* Amount of switch ports */
+	int is_100_mbits;	/* Is it configured to 100 or 1000 mbit/s */
+	int qbv_support;	/* Qbv support on front TSN ports */
+	int qbv_on_cpu_port;	/* Qbv support on the CPU port */
+	int qbu_support;	/* Qbu support on front TSN ports */
+	u16 module_id;		/* Module identificaton */
+};
+
+#endif /* _HIRSCHMANN_HELLCREEK_H_ */
-- 
2.20.1

