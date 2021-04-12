Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AC35C9AE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242811AbhDLPWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242701AbhDLPWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 11:22:39 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B07C061574;
        Mon, 12 Apr 2021 08:22:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id b17so9648276pgh.7;
        Mon, 12 Apr 2021 08:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=heNSwPi0int1P5QDm5ln5X99G0pw8YSxe0UTyMqxqq8=;
        b=AmXyu42uTTGnNGfK7OXPwoqRq/Tb6EoKLno/XTZuyRB7jVWEaLIITjfXJuwyENMMKR
         oRJTB7Ay6llq3aFnUvBrAiK4Vj8Y4VeTyolLbPQDb9kB5FjqTfbBSUpAitVDHVowNUlt
         olStN4Wvt9Qa4noQHvyCHF1mlLuHmVmlvEq1EdhEoWn9+FSCtX0RrlLEfeIhQ10E2Zd3
         PWzpyQZqoGMCc8OPIfj86hNk7N2ihmPFwF65HjwFgD0d90k72kQ5ZQnPYKtEdcPwW+eU
         etw0eWY1ycWaBADWh3goN8mz5bRJDGXpCao+XzP9miPK35q4e1UAxsgBsBqBOxddTC3l
         IRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=heNSwPi0int1P5QDm5ln5X99G0pw8YSxe0UTyMqxqq8=;
        b=ooWZHOlbTNoxQyYJfOpIm/XlLgjKZALcuTjAFz2ZQmyr40hKmm9yn+6DeDtGsZ4SrN
         ZUlvjZ9XAioiBx4wGOqZx+3E5/Qu9Sh9cqG+dlDECe4AIV1aEyRCWv7tl2sCqbetC7cr
         LGZmHAwBu1cfLVpuq7v90vRzg/S8HQMbTmRm/jH9m2Rdj9BEyoNVXtzgVMxRS1sdPBRJ
         LdkvmXTLJT2P7f7KB7Yl4tjnMOMOHWBdWxLIjwWirW8556WcJq8VJH39XbPyEPUwPHDa
         0T3366OJtUZEsJUMSueFDgQWCiBrPmZDB/M0SMCAVqGfNDqbyR1ZZmm/dJrErxszLcNL
         xczw==
X-Gm-Message-State: AOAM533dNMHA/tZ5hJ75Q3IXCaunjtD+evGAKWD1E7LwapefdE6fYkTV
        C7StuQWHuJ7mN0+vlYF+tuE=
X-Google-Smtp-Source: ABdhPJxPmGcOY26SAi300wuUzIJieWRRUUbZqaPLCX36OTlBBcEX+QARkqD0u7b0qPtrtbHjDRGReA==
X-Received: by 2002:aa7:88d4:0:b029:24e:93bf:f472 with SMTP id k20-20020aa788d40000b029024e93bff472mr2692600pff.8.1618240940791;
        Mon, 12 Apr 2021 08:22:20 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id np15sm11113308pjb.3.2021.04.12.08.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:22:20 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Ungerer <gerg@kernel.org>
Subject: Re: [RFC v4 net-next 2/4] net: dsa: mt7530: add interrupt support
Date:   Mon, 12 Apr 2021 23:22:10 +0800
Message-Id: <20210412152210.929733-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87fszvoqvb.wl-maz@kernel.org>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-3-dqfext@gmail.com> <87fszvoqvb.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 09:21:12AM +0100, Marc Zyngier wrote:
> On Mon, 12 Apr 2021 04:42:35 +0100,
> DENG Qingfang <dqfext@gmail.com> wrote:
> > 
> > Add support for MT7530 interrupt controller to handle internal PHYs.
> > In order to assign an IRQ number to each PHY, the registration of MDIO bus
> > is also done in this driver.
> > 
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> > RFC v3 -> RFC v4:
> > - No changes.
> > 
> >  drivers/net/dsa/Kconfig  |   1 +
> >  drivers/net/dsa/mt7530.c | 266 +++++++++++++++++++++++++++++++++++----
> >  drivers/net/dsa/mt7530.h |  20 ++-
> >  3 files changed, 258 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> > index a5f1aa911fe2..264384449f09 100644
> > --- a/drivers/net/dsa/Kconfig
> > +++ b/drivers/net/dsa/Kconfig
> > @@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
> >  config NET_DSA_MT7530
> >  	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
> >  	select NET_DSA_TAG_MTK
> > +	select MEDIATEK_PHY
> >  	help
> >  	  This enables support for the MediaTek MT7530, MT7531, and MT7621
> >  	  Ethernet switch chips.
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 2bd1bab71497..da033004a74d 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/mfd/syscon.h>
> >  #include <linux/module.h>
> >  #include <linux/netdevice.h>
> > +#include <linux/of_irq.h>
> >  #include <linux/of_mdio.h>
> >  #include <linux/of_net.h>
> >  #include <linux/of_platform.h>
> > @@ -596,18 +597,14 @@ mt7530_mib_reset(struct dsa_switch *ds)
> >  	mt7530_write(priv, MT7530_MIB_CCR, CCR_MIB_ACTIVATE);
> >  }
> >  
> > -static int mt7530_phy_read(struct dsa_switch *ds, int port, int regnum)
> > +static int mt7530_phy_read(struct mt7530_priv *priv, int port, int regnum)
> >  {
> > -	struct mt7530_priv *priv = ds->priv;
> > -
> >  	return mdiobus_read_nested(priv->bus, port, regnum);
> >  }
> >  
> > -static int mt7530_phy_write(struct dsa_switch *ds, int port, int regnum,
> > +static int mt7530_phy_write(struct mt7530_priv *priv, int port, int regnum,
> >  			    u16 val)
> >  {
> > -	struct mt7530_priv *priv = ds->priv;
> > -
> >  	return mdiobus_write_nested(priv->bus, port, regnum, val);
> >  }
> >  
> > @@ -785,9 +782,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
> >  }
> >  
> >  static int
> > -mt7531_ind_phy_read(struct dsa_switch *ds, int port, int regnum)
> > +mt7531_ind_phy_read(struct mt7530_priv *priv, int port, int regnum)
> >  {
> > -	struct mt7530_priv *priv = ds->priv;
> >  	int devad;
> >  	int ret;
> >  
> > @@ -803,10 +799,9 @@ mt7531_ind_phy_read(struct dsa_switch *ds, int port, int regnum)
> >  }
> >  
> >  static int
> > -mt7531_ind_phy_write(struct dsa_switch *ds, int port, int regnum,
> > +mt7531_ind_phy_write(struct mt7530_priv *priv, int port, int regnum,
> >  		     u16 data)
> >  {
> > -	struct mt7530_priv *priv = ds->priv;
> >  	int devad;
> >  	int ret;
> >  
> > @@ -822,6 +817,22 @@ mt7531_ind_phy_write(struct dsa_switch *ds, int port, int regnum,
> >  	return ret;
> >  }
> >  
> > +static int
> > +mt753x_phy_read(struct mii_bus *bus, int port, int regnum)
> > +{
> > +	struct mt7530_priv *priv = bus->priv;
> > +
> > +	return priv->info->phy_read(priv, port, regnum);
> > +}
> > +
> > +static int
> > +mt753x_phy_write(struct mii_bus *bus, int port, int regnum, u16 val)
> > +{
> > +	struct mt7530_priv *priv = bus->priv;
> > +
> > +	return priv->info->phy_write(priv, port, regnum, val);
> > +}
> > +
> >  static void
> >  mt7530_get_strings(struct dsa_switch *ds, int port, u32 stringset,
> >  		   uint8_t *data)
> > @@ -1828,6 +1839,211 @@ mt7530_setup_gpio(struct mt7530_priv *priv)
> >  }
> >  #endif /* CONFIG_GPIOLIB */
> >  
> > +static irqreturn_t
> > +mt7530_irq_thread_fn(int irq, void *dev_id)
> > +{
> > +	struct mt7530_priv *priv = dev_id;
> > +	bool handled = false;
> > +	u32 val;
> > +	int p;
> > +
> > +	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	val = mt7530_mii_read(priv, MT7530_SYS_INT_STS);
> > +	mt7530_mii_write(priv, MT7530_SYS_INT_STS, val);
> > +	mutex_unlock(&priv->bus->mdio_lock);
> > +
> > +	for (p = 0; p < MT7530_NUM_PHYS; p++) {
> > +		if (BIT(p) & val) {
> > +			unsigned int irq;
> > +
> > +			irq = irq_find_mapping(priv->irq_domain, p);
> > +			handle_nested_irq(irq);
> > +			handled = true;
> > +		}
> > +	}
> > +
> > +	return IRQ_RETVAL(handled);
> > +}
> > +
> > +static void
> > +mt7530_irq_mask(struct irq_data *d)
> > +{
> > +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +	priv->irq_enable &= ~BIT(d->hwirq);
> > +}
> > +
> > +static void
> > +mt7530_irq_unmask(struct irq_data *d)
> > +{
> > +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +	priv->irq_enable |= BIT(d->hwirq);
> > +}
> > +
> > +static void
> > +mt7530_irq_bus_lock(struct irq_data *d)
> > +{
> > +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +}
> > +
> > +static void
> > +mt7530_irq_bus_sync_unlock(struct irq_data *d)
> > +{
> > +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +	mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
> > +	mutex_unlock(&priv->bus->mdio_lock);
> > +}
> > +
> > +static struct irq_chip mt7530_irq_chip = {
> > +	.name = KBUILD_MODNAME,
> > +	.irq_mask = mt7530_irq_mask,
> > +	.irq_unmask = mt7530_irq_unmask,
> > +	.irq_bus_lock = mt7530_irq_bus_lock,
> > +	.irq_bus_sync_unlock = mt7530_irq_bus_sync_unlock,
> > +};
> > +
> > +static int
> > +mt7530_irq_map(struct irq_domain *domain, unsigned int irq,
> > +	       irq_hw_number_t hwirq)
> > +{
> > +	irq_set_chip_data(irq, domain->host_data);
> > +	irq_set_chip_and_handler(irq, &mt7530_irq_chip, handle_simple_irq);
> > +	irq_set_nested_thread(irq, true);
> > +	irq_set_noprobe(irq);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct irq_domain_ops mt7530_irq_domain_ops = {
> > +	.map = mt7530_irq_map,
> > +	.xlate = irq_domain_xlate_onecell,
> > +};
> > +
> > +static void
> > +mt7530_setup_mdio_irq(struct mt7530_priv *priv)
> > +{
> > +	struct dsa_switch *ds = priv->ds;
> > +	int p;
> > +
> > +	for (p = 0; p < MT7530_NUM_PHYS; p++) {
> > +		if (BIT(p) & ds->phys_mii_mask) {
> > +			unsigned int irq;
> > +
> > +			irq = irq_create_mapping(priv->irq_domain, p);
> 
> This seems odd. Why aren't the MDIO IRQs allocated on demand as
> endpoint attached to this interrupt controller are being probed
> individually? In general, doing this allocation upfront is an
> indication that there is some missing information in the DT to perform
> the discovery.

This is what Andrew's mv88e6xxx does, actually. In addition, I also check
the phys_mii_mask to avoid creating mappings for unused ports.

Andrew, perhaps this can be done in DSA core?

> 
> > +			ds->slave_mii_bus->irq[p] = irq;
> > +		}
> > +	}
> > +}
> > +
> > +static int
> > +mt7530_setup_irq(struct mt7530_priv *priv)
> > +{
> > +	struct device *dev = priv->dev;
> > +	struct device_node *np = dev->of_node;
> > +	int ret;
> > +
> > +	if (!of_property_read_bool(np, "interrupt-controller")) {
> > +		dev_info(dev, "no interrupt support\n");
> > +		return 0;
> > +	}
> > +
> > +	priv->irq = of_irq_get(np, 0);
> > +	if (priv->irq <= 0) {
> > +		dev_err(dev, "failed to get parent IRQ: %d\n", priv->irq);
> > +		return priv->irq ? : -EINVAL;
> > +	}
> > +
> > +	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
> > +						&mt7530_irq_domain_ops, priv);
> > +	if (!priv->irq_domain) {
> > +		dev_err(dev, "failed to create IRQ domain\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* This register must be set for MT7530 to properly fire interrupts */
> > +	if (priv->id != ID_MT7531)
> 
> Why not check for ID_MT7530 directly then?

There is also ID_MT7621, introduced by Greg Ungerer, but it is basically
MT7530 too.

> 
> > +		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
> > +
> > +	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
> > +				   IRQF_ONESHOT, KBUILD_MODNAME, priv);
> > +	if (ret) {
> > +		irq_domain_remove(priv->irq_domain);
> > +		dev_err(dev, "failed to request IRQ: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void
> > +mt7530_free_mdio_irq(struct mt7530_priv *priv)
> > +{
> > +	int p;
> > +
> > +	for (p = 0; p < MT7530_NUM_PHYS; p++) {
> > +		if (BIT(p) & priv->ds->phys_mii_mask) {
> > +			unsigned int irq;
> > +
> > +			irq = irq_find_mapping(priv->irq_domain, p);
> > +			irq_dispose_mapping(irq);
> > +		}
> > +	}
> > +}
> > +
> > +
> > +static void
> > +mt7530_free_irq_common(struct mt7530_priv *priv)
> > +{
> > +	free_irq(priv->irq, priv);
> > +	irq_domain_remove(priv->irq_domain);
> > +}
> > +
> > +static void
> > +mt7530_free_irq(struct mt7530_priv *priv)
> > +{
> > +	mt7530_free_mdio_irq(priv);
> > +	mt7530_free_irq_common(priv);
> > +}
> > +
> > +static int
> > +mt7530_setup_mdio(struct mt7530_priv *priv)
> > +{
> > +	struct dsa_switch *ds = priv->ds;
> > +	struct device *dev = priv->dev;
> > +	struct mii_bus *bus;
> > +	static int idx;
> > +	int ret;
> > +
> > +	bus = devm_mdiobus_alloc(dev);
> > +	if (!bus)
> > +		return -ENOMEM;
> > +
> > +	ds->slave_mii_bus = bus;
> > +	bus->priv = priv;
> > +	bus->name = KBUILD_MODNAME "-mii";
> > +	snprintf(bus->id, MII_BUS_ID_SIZE, KBUILD_MODNAME "-%d", idx++);
> > +	bus->read = mt753x_phy_read;
> > +	bus->write = mt753x_phy_write;
> > +	bus->parent = dev;
> > +	bus->phy_mask = ~ds->phys_mii_mask;
> > +
> > +	if (priv->irq)
> > +		mt7530_setup_mdio_irq(priv);
> > +
> > +	ret = mdiobus_register(bus);
> > +	if (ret) {
> > +		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
> > +		if (priv->irq)
> > +			mt7530_free_mdio_irq(priv);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  static int
> >  mt7530_setup(struct dsa_switch *ds)
> >  {
> > @@ -2780,32 +2996,25 @@ static int
> >  mt753x_setup(struct dsa_switch *ds)
> >  {
> >  	struct mt7530_priv *priv = ds->priv;
> > +	int ret = priv->info->sw_setup(ds);
> > +	if (ret)
> > +		return ret;
> >  
> > -	return priv->info->sw_setup(ds);
> > -}
> > -
> > -static int
> > -mt753x_phy_read(struct dsa_switch *ds, int port, int regnum)
> > -{
> > -	struct mt7530_priv *priv = ds->priv;
> > -
> > -	return priv->info->phy_read(ds, port, regnum);
> > -}
> > +	ret = mt7530_setup_irq(priv);
> > +	if (ret)
> > +		return ret;
> >  
> > -static int
> > -mt753x_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
> > -{
> > -	struct mt7530_priv *priv = ds->priv;
> > +	ret = mt7530_setup_mdio(priv);
> > +	if (ret && priv->irq)
> > +		mt7530_free_irq_common(priv);
> >  
> > -	return priv->info->phy_write(ds, port, regnum, val);
> > +	return ret;
> >  }
> >  
> >  static const struct dsa_switch_ops mt7530_switch_ops = {
> >  	.get_tag_protocol	= mtk_get_tag_protocol,
> >  	.setup			= mt753x_setup,
> >  	.get_strings		= mt7530_get_strings,
> > -	.phy_read		= mt753x_phy_read,
> > -	.phy_write		= mt753x_phy_write,
> 
> I don't get why this change is part of the interrupt support. This
> should probably be a separate patch.

These 2 functions are for DSA slave MII bus. Since the driver now manages
the MII bus, mt753x_phy_{read,write} are assigned to bus->{read,write}
instead.

> 
> >  	.get_ethtool_stats	= mt7530_get_ethtool_stats,
> >  	.get_sset_count		= mt7530_get_sset_count,
> >  	.set_ageing_time	= mt7530_set_ageing_time,
> > @@ -2986,6 +3195,9 @@ mt7530_remove(struct mdio_device *mdiodev)
> >  		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
> >  			ret);
> >  
> > +	if (priv->irq)
> > +		mt7530_free_irq(priv);
> > +
> >  	dsa_unregister_switch(priv->ds);
> >  	mutex_destroy(&priv->reg_mutex);
> >  }
> > diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> > index ec36ea5dfd57..62fcaabefba1 100644
> > --- a/drivers/net/dsa/mt7530.h
> > +++ b/drivers/net/dsa/mt7530.h
> 
> nit: Another thing is that I don't see why this include file exists at
> all. The only user is mt7530.c, so the two could be merged and reduce
> the clutter.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
