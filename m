Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F5F3562AF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbhDGEvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbhDGEvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 00:51:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E6C06174A;
        Tue,  6 Apr 2021 21:51:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k8so12107312pgf.4;
        Tue, 06 Apr 2021 21:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dXH7gsc9ZKZ4bOhQIUiJFxIFBNVErOjlbzXwxiqkYj0=;
        b=EePu3u8KElU6Unyabuflov6OEDg1cLYnJeVi3ZYg8K6lsQUtjpqcOhrHCihQwx/pEj
         M2kcWD09kJNnZA3rKy7+agSHG2MG+YuSd3X2+iF67qHPsR2r+mIv9csAKkTv5PxB03ze
         A5QHU1WDrggxwOGWL4Bqj58No9+2kQHg8m1WDYCktOZPg/uP1lTYkNvn3xiEQBOVhzKx
         s9+N3y37m2q1MaI+eSOKD2dZpckafZNyd4waVhJzNG0Qn8gcTfEfqmNwBgAb4kUTo0o5
         JZjEdgn8ySf/UB6/ZprJc6rfJvmFpR6qENXNejGd/309cIV4W2pghamBeVD4NxQwnrKN
         oCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXH7gsc9ZKZ4bOhQIUiJFxIFBNVErOjlbzXwxiqkYj0=;
        b=WY2kPn8UL35hk0vsoyXj+2VS38yG7vAqTVjIKNsK7O5M1/OHDP5g7bpWW8BK0CtqzZ
         SHXjWMG41hMQ1qhu/l4HzPVx3OvZQHngGahDIso9Xmo7UuLG8G2Xu7/EBlN1PpsPwvy/
         g/aW7vXtUNQlMcmFxdgPxsTrmeVgrNf4FCwkC8Vf7WtsT5mc3QVOAiZsG37OzIwEJd5w
         qr8eQJhxFd1urcBBRF6lz3g+la/WmoeQaWUtelmI6wE2swR6h/xxv9Axom2W2crgBATe
         TnkOicTvKunesmN0ndQmyeaJx/ZuR04xLsY7lQ9VV7tWEbiTtKJO+PEELl+yb0C1+oI2
         NQPQ==
X-Gm-Message-State: AOAM532hYMoodwf6OkCCMR8vHx8ngzReeRJ2SEk8Qh02skvHyanEsG9u
        cdPsmBQ3iRxoPFUUt+F5ISI=
X-Google-Smtp-Source: ABdhPJzb1k0MYADzItGJYE6WihUFVU/MnqAUX0VED5zN39usAJjqSA2y+j6fcFcrgvNqHOeEVQKqXQ==
X-Received: by 2002:aa7:8756:0:b029:242:3e63:87da with SMTP id g22-20020aa787560000b02902423e6387damr761589pfo.66.1617771062032;
        Tue, 06 Apr 2021 21:51:02 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id n52sm882679pfv.13.2021.04.06.21.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 21:51:01 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [RFC v2 net-next 2/4] net: dsa: mt7530: add interrupt support
Date:   Wed,  7 Apr 2021 12:50:36 +0800
Message-Id: <20210407045038.1436843-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210407045038.1436843-1-dqfext@gmail.com>
References: <20210407045038.1436843-1-dqfext@gmail.com>
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
RFC v1 -> RFC v2:
- Split MDIO and IRQ setup function

 drivers/net/dsa/Kconfig  |   1 +
 drivers/net/dsa/mt7530.c | 238 +++++++++++++++++++++++++++++++++++----
 drivers/net/dsa/mt7530.h |  18 ++-
 3 files changed, 236 insertions(+), 21 deletions(-)

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
index 2bd1bab71497..813703339db0 100644
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
 
@@ -1828,6 +1823,202 @@ mt7530_setup_gpio(struct mt7530_priv *priv)
 }
 #endif /* CONFIG_GPIOLIB */
 
+static irqreturn_t
+mt7530_irq(int irq, void *data)
+{
+	struct mt7530_priv *priv = data;
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
+			handle_nested_irq(irq_find_mapping(priv->irq_domain,
+					  p));
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
+	int parent_irq, ret;
+
+	if (!of_property_read_bool(np, "interrupt-controller")) {
+		dev_info(dev, "no interrupt support\n");
+		return 0;
+	}
+
+	parent_irq = of_irq_get(np, 0);
+	if (parent_irq <= 0) {
+		dev_err(dev, "failed to get parent IRQ: %d\n", parent_irq);
+		return parent_irq ? : -EINVAL;
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
+	ret = devm_request_threaded_irq(dev, parent_irq, NULL, mt7530_irq,
+					IRQF_ONESHOT, KBUILD_MODNAME, priv);
+	if (ret) {
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
+static void
+mt7530_free_irq(struct mt7530_priv *priv)
+{
+	mt7530_free_mdio_irq(priv);
+
+	irq_domain_remove(priv->irq_domain);
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
+	if (priv->irq_domain)
+		mt7530_setup_mdio_irq(priv);
+
+	ret = mdiobus_register(bus);
+	if (ret) {
+		if (priv->irq_domain)
+			mt7530_free_irq(priv);
+
+		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int
 mt7530_setup(struct dsa_switch *ds)
 {
@@ -2780,32 +2971,38 @@ static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret = priv->info->sw_setup(ds);
+
+	if (ret)
+		return ret;
 
-	return priv->info->sw_setup(ds);
+	ret = mt7530_setup_irq(priv);
+	if (ret)
+		return ret;
+
+	return mt7530_setup_mdio(priv);
 }
 
 static int
-mt753x_phy_read(struct dsa_switch *ds, int port, int regnum)
+mt753x_phy_read(struct mii_bus *bus, int port, int regnum)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = bus->priv;
 
-	return priv->info->phy_read(ds, port, regnum);
+	return priv->info->phy_read(priv, port, regnum);
 }
 
 static int
-mt753x_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
+mt753x_phy_write(struct mii_bus *bus, int port, int regnum, u16 val)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = bus->priv;
 
-	return priv->info->phy_write(ds, port, regnum, val);
+	return priv->info->phy_write(priv, port, regnum, val);
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
@@ -2986,6 +3183,9 @@ mt7530_remove(struct mdio_device *mdiodev)
 		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
 			ret);
 
+	if (priv->irq_domain)
+		mt7530_free_irq(priv);
+
 	dsa_unregister_switch(priv->ds);
 	mutex_destroy(&priv->reg_mutex);
 }
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ec36ea5dfd57..e4429e152cde 100644
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
@@ -702,6 +709,11 @@ static const char *p5_intf_modes(unsigned int p5_interface)
 	}
 }
 
+/* Forward declaration */
+struct mt7530_priv;
+static int mt753x_phy_read(struct mii_bus *, int, int);
+static int mt753x_phy_write(struct mii_bus *, int, int, u16);
+
 /* struct mt753x_info -	This is the main data structure for holding the specific
  *			part for each supported device
  * @sw_setup:		Holding the handler to a device initialization
@@ -726,8 +738,8 @@ struct mt753x_info {
 	enum mt753x_id id;
 
 	int (*sw_setup)(struct dsa_switch *ds);
-	int (*phy_read)(struct dsa_switch *ds, int port, int regnum);
-	int (*phy_write)(struct dsa_switch *ds, int port, int regnum, u16 val);
+	int (*phy_read)(struct mt7530_priv *priv, int port, int regnum);
+	int (*phy_write)(struct mt7530_priv *priv, int port, int regnum, u16 val);
 	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	bool (*phy_mode_supported)(struct dsa_switch *ds, int port,
@@ -782,6 +794,8 @@ struct mt7530_priv {
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
 	struct mutex reg_mutex;
+	struct irq_domain *irq_domain;
+	u32 irq_enable;
 };
 
 struct mt7530_hw_vlan_entry {
-- 
2.25.1

