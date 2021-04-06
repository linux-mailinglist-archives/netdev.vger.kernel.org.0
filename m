Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42388355664
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345015AbhDFOUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345032AbhDFOSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 10:18:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428EEC061756;
        Tue,  6 Apr 2021 07:18:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k8so10475359pgf.4;
        Tue, 06 Apr 2021 07:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qu0GD9BQYntU3CV32u3Nqjw63JJRWZmv1NZ6yrLmkqs=;
        b=qTWTXUKRQmnzKvgnGANELA2llCjQV03QN/x4p0XFCBvDB6DPT3d+XkMarNF0SuGw7O
         gx3OKjw58MRKVlrg8LcxIdZ9CJF31+KxscnzeRqQOQ8qMVqFDbrcLoVutOda2ikPdz0k
         i26BnI09f6uyGTaXbCKSma8AKQf8uNtyiUvdJWCWGI+8hxnOVqsEnBx7XdHzqBt7f0Wn
         OGI/yTzve5fIVlulPEBxJ743lRlcfZd+fWS1IoEZPhipupXz6NFxWFM3Q2ARg5K4iqm/
         sr7ojYPyXiJPWB7Buy7AxN3opJJc9WfjqwHPf420xBu6O7u60loxfdl8a0KL/Z/a4lA7
         m/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qu0GD9BQYntU3CV32u3Nqjw63JJRWZmv1NZ6yrLmkqs=;
        b=mbvQzz+3fhHnxALf8liiFfaKBk0T1lX59s3q7eqrW/aWgwAjnIIILeOwzlNVkdATKH
         DZJFQhNTrJF0w2M81sf6fzJmeY+PJ75qK4WlLDaq5eYj9Z0nYJJhwZHsCepXB5SIcrOW
         uaniO0fF6hKBdyrzv3e4+2kZr48hp73t6XA9znOi3epsEQ0EJSPmrXvGV8QIucsiKEDx
         SmraoMVu2PgR18Zam/Cw55xoekBFe9fPyX17pSJh02oMY4NfljP26yDDuPCpRGinq7ZE
         54ebOmL2HLhmKmXwGsG3koBh5GwwGalTnymD3Ci3Ndp3Duw5cTzcX/O/cCt+G+jl/Lq3
         gjfA==
X-Gm-Message-State: AOAM533DYwyUC385OSzQvthu8l9XizkTozVtKdxzR4TSUMI0y6Wcn1pp
        zt3iVw7KdLdRYON+CwfJKs8=
X-Google-Smtp-Source: ABdhPJzyEMeFwnagyL0RdhuaGemaFMJLlZmHSZhSYmoyMDeElBVNCON/g4Ri2lcHC117RxfsX0VWGg==
X-Received: by 2002:a65:66c3:: with SMTP id c3mr25755606pgw.355.1617718723791;
        Tue, 06 Apr 2021 07:18:43 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u1sm18337581pgg.11.2021.04.06.07.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 07:18:42 -0700 (PDT)
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
Subject: [RFC net-next 2/4] net: dsa: mt7530: add interrupt support
Date:   Tue,  6 Apr 2021 22:18:17 +0800
Message-Id: <20210406141819.1025864-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406141819.1025864-1-dqfext@gmail.com>
References: <20210406141819.1025864-1-dqfext@gmail.com>
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
 drivers/net/dsa/mt7530.c | 203 +++++++++++++++++++++++++++++++++++----
 drivers/net/dsa/mt7530.h |  18 +++-
 2 files changed, 200 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2bd1bab71497..4c334e90090b 100644
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
 
@@ -1828,6 +1823,159 @@ mt7530_setup_gpio(struct mt7530_priv *priv)
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
+static int
+mt7530_setup_mdiobus_irq(struct mt7530_priv *priv)
+{
+	struct device *dev = priv->dev;
+	struct device_node *np = dev->of_node;
+	struct dsa_switch *ds = priv->ds;
+	int parent_irq, ret, p;
+	struct mii_bus *bus;
+	static int idx;
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
+	if (!of_property_read_bool(np, "interrupt-controller")) {
+		dev_info(dev, "no interrupt support\n");
+		goto register_mdiobus;
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
+	for (p = 0; p < MT7530_NUM_PHYS; p++) {
+		if (BIT(p) & ds->phys_mii_mask) {
+			unsigned int irq;
+
+			irq = irq_create_mapping(priv->irq_domain, p);
+			irq_set_parent(irq, parent_irq);
+			bus->irq[p] = irq;
+		}
+	}
+
+register_mdiobus:
+	ret = mdiobus_register(bus);
+	if (ret) {
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
@@ -2780,32 +2928,34 @@ static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret = priv->info->sw_setup(ds);
+
+	if (!ret)
+		ret = mt7530_setup_mdiobus_irq(priv);
 
-	return priv->info->sw_setup(ds);
+	return ret;
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
@@ -2986,6 +3136,21 @@ mt7530_remove(struct mdio_device *mdiodev)
 		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
 			ret);
 
+	if (priv->irq_domain) {
+		int p;
+
+		for (p = 0; p < MT7530_NUM_PHYS; p++) {
+			if (BIT(p) & priv->ds->phys_mii_mask) {
+				unsigned int irq;
+
+				irq = irq_find_mapping(priv->irq_domain, p);
+				irq_dispose_mapping(irq);
+			}
+		}
+
+		irq_domain_remove(priv->irq_domain);
+	}
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

