Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4ABF35B906
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhDLDnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbhDLDnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:43:22 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B805C061574;
        Sun, 11 Apr 2021 20:43:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t22so5309596ply.1;
        Sun, 11 Apr 2021 20:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5iVy9Qcyd/0kvs5rJnuGEArCW/7WVX29m/AJAXhyoBk=;
        b=PZsgk8IRMw6NlE4y40V8k5hOpnQ9c6JZac2VHiKop8XGj5yUyePy17NrpAqXAkaBIg
         1FB2R1Boop42pdUP+IbWUro2DSD3ilxyYBdkF1EzzQMe19yQLk85DyuRn4ljpy0prHQQ
         8j6PiYIjjrZanrDgIphHxQ+Pn5HQdh1mtBhETj5pIk75BTbV/k42Ml5RPFGl3nQ3YmNm
         ZZcN+p01de2vSS/fq5u7zR2EcwjQY4MXcBcrmm/rkwejHQOeOvS0Nkm55sz4lA3/kguE
         IPHtmlpm2ensTbJfH7bUX10JVZpP5rh1IopC2azD+YWpqP03YgCALY3EDseXJmfBRBvC
         5R6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5iVy9Qcyd/0kvs5rJnuGEArCW/7WVX29m/AJAXhyoBk=;
        b=BSLD0pXapV9JQHatbqDn9SHqvrKTAMYq392DEAJV1aYWqftFsdO0mK6zsMw8sAomQx
         nGazDrkV5NxhoSObCuufux3hxsASaLVPKVmx2JKI5Y2AzOnNbHI2PjNKst5KC7sC3tXl
         Ed/5HL5dmxWiKmzMbv2C1tyoXNwhHUSWF54GW2Rf73NbiElRqVC8ZX7lGTTh9lkGXPie
         k7FSBjHuiOjp++8wcUCoRqzX6mpmOwCBMC34R49TD8gVpcBIP1+nrsZ4mJwC+srKgZ5D
         YP89tqNY2Go7mByMRtyOyOUvBt+cxX8Hj7Oa6r8JyIw/VaTOhwb4FPXotNw1ZEXQfPxR
         7Txw==
X-Gm-Message-State: AOAM531wjfnLin290w2h8V0HBC3tBFQrm3pgUPal8pNou+E4VNJ15rC+
        7zam3/6nFhoI7f2aLqmFFuc=
X-Google-Smtp-Source: ABdhPJyGJKPqTcB2WhCGQqxU3A0XXNr8MxsG2Glnt/Rly/I9okZWOsVIhOwHcwpcEUtrRLjB1S4XyA==
X-Received: by 2002:a17:902:d305:b029:ea:db56:e7d with SMTP id b5-20020a170902d305b02900eadb560e7dmr7322836plc.66.1618198983108;
        Sun, 11 Apr 2021 20:43:03 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v22sm5387185pff.105.2021.04.11.20.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:43:02 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [RFC v4 net-next 2/4] net: dsa: mt7530: add interrupt support
Date:   Mon, 12 Apr 2021 11:42:35 +0800
Message-Id: <20210412034237.2473017-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412034237.2473017-1-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MT7530 interrupt controller to handle internal PHYs.
In order to assign an IRQ number to each PHY, the registration of MDIO bus
is also done in this driver.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC v3 -> RFC v4:
- No changes.

 drivers/net/dsa/Kconfig  |   1 +
 drivers/net/dsa/mt7530.c | 266 +++++++++++++++++++++++++++++++++++----
 drivers/net/dsa/mt7530.h |  20 ++-
 3 files changed, 258 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index a5f1aa911fe2..264384449f09 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2bd1bab71497..da033004a74d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -10,6 +10,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
@@ -596,18 +597,14 @@ mt7530_mib_reset(struct dsa_switch *ds)
 	mt7530_write(priv, MT7530_MIB_CCR, CCR_MIB_ACTIVATE);
 }
 
-static int mt7530_phy_read(struct dsa_switch *ds, int port, int regnum)
+static int mt7530_phy_read(struct mt7530_priv *priv, int port, int regnum)
 {
-	struct mt7530_priv *priv = ds->priv;
-
 	return mdiobus_read_nested(priv->bus, port, regnum);
 }
 
-static int mt7530_phy_write(struct dsa_switch *ds, int port, int regnum,
+static int mt7530_phy_write(struct mt7530_priv *priv, int port, int regnum,
 			    u16 val)
 {
-	struct mt7530_priv *priv = ds->priv;
-
 	return mdiobus_write_nested(priv->bus, port, regnum, val);
 }
 
@@ -785,9 +782,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 }
 
 static int
-mt7531_ind_phy_read(struct dsa_switch *ds, int port, int regnum)
+mt7531_ind_phy_read(struct mt7530_priv *priv, int port, int regnum)
 {
-	struct mt7530_priv *priv = ds->priv;
 	int devad;
 	int ret;
 
@@ -803,10 +799,9 @@ mt7531_ind_phy_read(struct dsa_switch *ds, int port, int regnum)
 }
 
 static int
-mt7531_ind_phy_write(struct dsa_switch *ds, int port, int regnum,
+mt7531_ind_phy_write(struct mt7530_priv *priv, int port, int regnum,
 		     u16 data)
 {
-	struct mt7530_priv *priv = ds->priv;
 	int devad;
 	int ret;
 
@@ -822,6 +817,22 @@ mt7531_ind_phy_write(struct dsa_switch *ds, int port, int regnum,
 	return ret;
 }
 
+static int
+mt753x_phy_read(struct mii_bus *bus, int port, int regnum)
+{
+	struct mt7530_priv *priv = bus->priv;
+
+	return priv->info->phy_read(priv, port, regnum);
+}
+
+static int
+mt753x_phy_write(struct mii_bus *bus, int port, int regnum, u16 val)
+{
+	struct mt7530_priv *priv = bus->priv;
+
+	return priv->info->phy_write(priv, port, regnum, val);
+}
+
 static void
 mt7530_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 		   uint8_t *data)
@@ -1828,6 +1839,211 @@ mt7530_setup_gpio(struct mt7530_priv *priv)
 }
 #endif /* CONFIG_GPIOLIB */
 
+static irqreturn_t
+mt7530_irq_thread_fn(int irq, void *dev_id)
+{
+	struct mt7530_priv *priv = dev_id;
+	bool handled = false;
+	u32 val;
+	int p;
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	val = mt7530_mii_read(priv, MT7530_SYS_INT_STS);
+	mt7530_mii_write(priv, MT7530_SYS_INT_STS, val);
+	mutex_unlock(&priv->bus->mdio_lock);
+
+	for (p = 0; p < MT7530_NUM_PHYS; p++) {
+		if (BIT(p) & val) {
+			unsigned int irq;
+
+			irq = irq_find_mapping(priv->irq_domain, p);
+			handle_nested_irq(irq);
+			handled = true;
+		}
+	}
+
+	return IRQ_RETVAL(handled);
+}
+
+static void
+mt7530_irq_mask(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	priv->irq_enable &= ~BIT(d->hwirq);
+}
+
+static void
+mt7530_irq_unmask(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	priv->irq_enable |= BIT(d->hwirq);
+}
+
+static void
+mt7530_irq_bus_lock(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+}
+
+static void
+mt7530_irq_bus_sync_unlock(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
+	mutex_unlock(&priv->bus->mdio_lock);
+}
+
+static struct irq_chip mt7530_irq_chip = {
+	.name = KBUILD_MODNAME,
+	.irq_mask = mt7530_irq_mask,
+	.irq_unmask = mt7530_irq_unmask,
+	.irq_bus_lock = mt7530_irq_bus_lock,
+	.irq_bus_sync_unlock = mt7530_irq_bus_sync_unlock,
+};
+
+static int
+mt7530_irq_map(struct irq_domain *domain, unsigned int irq,
+	       irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(irq, domain->host_data);
+	irq_set_chip_and_handler(irq, &mt7530_irq_chip, handle_simple_irq);
+	irq_set_nested_thread(irq, true);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops mt7530_irq_domain_ops = {
+	.map = mt7530_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static void
+mt7530_setup_mdio_irq(struct mt7530_priv *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	int p;
+
+	for (p = 0; p < MT7530_NUM_PHYS; p++) {
+		if (BIT(p) & ds->phys_mii_mask) {
+			unsigned int irq;
+
+			irq = irq_create_mapping(priv->irq_domain, p);
+			ds->slave_mii_bus->irq[p] = irq;
+		}
+	}
+}
+
+static int
+mt7530_setup_irq(struct mt7530_priv *priv)
+{
+	struct device *dev = priv->dev;
+	struct device_node *np = dev->of_node;
+	int ret;
+
+	if (!of_property_read_bool(np, "interrupt-controller")) {
+		dev_info(dev, "no interrupt support\n");
+		return 0;
+	}
+
+	priv->irq = of_irq_get(np, 0);
+	if (priv->irq <= 0) {
+		dev_err(dev, "failed to get parent IRQ: %d\n", priv->irq);
+		return priv->irq ? : -EINVAL;
+	}
+
+	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
+						&mt7530_irq_domain_ops, priv);
+	if (!priv->irq_domain) {
+		dev_err(dev, "failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	/* This register must be set for MT7530 to properly fire interrupts */
+	if (priv->id != ID_MT7531)
+		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
+
+	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
+				   IRQF_ONESHOT, KBUILD_MODNAME, priv);
+	if (ret) {
+		irq_domain_remove(priv->irq_domain);
+		dev_err(dev, "failed to request IRQ: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void
+mt7530_free_mdio_irq(struct mt7530_priv *priv)
+{
+	int p;
+
+	for (p = 0; p < MT7530_NUM_PHYS; p++) {
+		if (BIT(p) & priv->ds->phys_mii_mask) {
+			unsigned int irq;
+
+			irq = irq_find_mapping(priv->irq_domain, p);
+			irq_dispose_mapping(irq);
+		}
+	}
+}
+
+
+static void
+mt7530_free_irq_common(struct mt7530_priv *priv)
+{
+	free_irq(priv->irq, priv);
+	irq_domain_remove(priv->irq_domain);
+}
+
+static void
+mt7530_free_irq(struct mt7530_priv *priv)
+{
+	mt7530_free_mdio_irq(priv);
+	mt7530_free_irq_common(priv);
+}
+
+static int
+mt7530_setup_mdio(struct mt7530_priv *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	struct device *dev = priv->dev;
+	struct mii_bus *bus;
+	static int idx;
+	int ret;
+
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
+		return -ENOMEM;
+
+	ds->slave_mii_bus = bus;
+	bus->priv = priv;
+	bus->name = KBUILD_MODNAME "-mii";
+	snprintf(bus->id, MII_BUS_ID_SIZE, KBUILD_MODNAME "-%d", idx++);
+	bus->read = mt753x_phy_read;
+	bus->write = mt753x_phy_write;
+	bus->parent = dev;
+	bus->phy_mask = ~ds->phys_mii_mask;
+
+	if (priv->irq)
+		mt7530_setup_mdio_irq(priv);
+
+	ret = mdiobus_register(bus);
+	if (ret) {
+		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
+		if (priv->irq)
+			mt7530_free_mdio_irq(priv);
+	}
+
+	return ret;
+}
+
 static int
 mt7530_setup(struct dsa_switch *ds)
 {
@@ -2780,32 +2996,25 @@ static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret = priv->info->sw_setup(ds);
+	if (ret)
+		return ret;
 
-	return priv->info->sw_setup(ds);
-}
-
-static int
-mt753x_phy_read(struct dsa_switch *ds, int port, int regnum)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	return priv->info->phy_read(ds, port, regnum);
-}
+	ret = mt7530_setup_irq(priv);
+	if (ret)
+		return ret;
 
-static int
-mt753x_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
-{
-	struct mt7530_priv *priv = ds->priv;
+	ret = mt7530_setup_mdio(priv);
+	if (ret && priv->irq)
+		mt7530_free_irq_common(priv);
 
-	return priv->info->phy_write(ds, port, regnum, val);
+	return ret;
 }
 
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
 	.get_strings		= mt7530_get_strings,
-	.phy_read		= mt753x_phy_read,
-	.phy_write		= mt753x_phy_write,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
 	.set_ageing_time	= mt7530_set_ageing_time,
@@ -2986,6 +3195,9 @@ mt7530_remove(struct mdio_device *mdiodev)
 		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
 			ret);
 
+	if (priv->irq)
+		mt7530_free_irq(priv);
+
 	dsa_unregister_switch(priv->ds);
 	mutex_destroy(&priv->reg_mutex);
 }
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ec36ea5dfd57..62fcaabefba1 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -7,6 +7,7 @@
 #define __MT7530_H
 
 #define MT7530_NUM_PORTS		7
+#define MT7530_NUM_PHYS			5
 #define MT7530_CPU_PORT			6
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
@@ -381,6 +382,12 @@ enum mt7531_sgmii_force_duplex {
 #define  SYS_CTRL_SW_RST		BIT(1)
 #define  SYS_CTRL_REG_RST		BIT(0)
 
+/* Register for system interrupt */
+#define MT7530_SYS_INT_EN		0x7008
+
+/* Register for system interrupt status */
+#define MT7530_SYS_INT_STS		0x700c
+
 /* Register for PHY Indirect Access Control */
 #define MT7531_PHY_IAC			0x701C
 #define  MT7531_PHY_ACS_ST		BIT(31)
@@ -702,6 +709,8 @@ static const char *p5_intf_modes(unsigned int p5_interface)
 	}
 }
 
+struct mt7530_priv;
+
 /* struct mt753x_info -	This is the main data structure for holding the specific
  *			part for each supported device
  * @sw_setup:		Holding the handler to a device initialization
@@ -726,8 +735,8 @@ struct mt753x_info {
 	enum mt753x_id id;
 
 	int (*sw_setup)(struct dsa_switch *ds);
-	int (*phy_read)(struct dsa_switch *ds, int port, int regnum);
-	int (*phy_write)(struct dsa_switch *ds, int port, int regnum, u16 val);
+	int (*phy_read)(struct mt7530_priv *priv, int port, int regnum);
+	int (*phy_write)(struct mt7530_priv *priv, int port, int regnum, u16 val);
 	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	bool (*phy_mode_supported)(struct dsa_switch *ds, int port,
@@ -761,6 +770,10 @@ struct mt753x_info {
  *			registers
  * @p6_interface	Holding the current port 6 interface
  * @p5_intf_sel:	Holding the current port 5 interface select
+ *
+ * @irq:		IRQ number of the switch
+ * @irq_domain:		IRQ domain of the switch irq_chip
+ * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -782,6 +795,9 @@ struct mt7530_priv {
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
 	struct mutex reg_mutex;
+	int irq;
+	struct irq_domain *irq_domain;
+	u32 irq_enable;
 };
 
 struct mt7530_hw_vlan_entry {
-- 
2.25.1

