Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19308690E71
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBIQha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBIQh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:37:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC515FF5;
        Thu,  9 Feb 2023 08:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ioCboKxLiQou52pFBMI7KKUyaBWeBLroYXbD/DuaNSQ=; b=EUEvW4KOarEzq1s1khGp4uXOpk
        p6eckODlR7zTKp/Wc7vnllyG+SfhiGjZZsLa7t4yci1Vof0EB6B0MZOKUS2hvktGzW3pZapo7ex/Y
        D6ZhGYXX/ugzMEiaf/LuyVYqa2o/qOKF/8c6utBQFHZdRyaamksFDuOFKYJ9r5dAV0bX3uQcDzmq5
        3sVrVKAkfr8bOHAB0O5EGVkvSROEMj0PAV/s7i+a7Pf51UWtc5l1GjGrJPIyDrXrAtewJsa0W0JfU
        WJx0M2uKcKErYc7r6Ctdq/qRPNsMudwJ5yoy+T0HbltJPtUBByEPMIp8QiHXuC8FhpB7T38rLWQ3n
        kd0kcoVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36482)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQ9vG-00088G-Re; Thu, 09 Feb 2023 16:37:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQ9vD-0004jd-Ux; Thu, 09 Feb 2023 16:37:19 +0000
Date:   Thu, 9 Feb 2023 16:37:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <Y+UhP1Ycq8a8RWJr@shell.armlinux.org.uk>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203122542.436305-1-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 01:25:42PM +0100, Horatiu Vultur wrote:
> +hw_init:
> +	/* 100BT Clause 40 improvenent errata */
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_1,
> +		      LAN8841_ANALOG_CONTROL_1_PLL_TRIM(0x2));
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_10,
> +		      LAN8841_ANALOG_CONTROL_10_PLL_DIV(0x1));
> +
> +	/* 10M/100M Ethernet Signal Tuning Errata for Shorted-Center Tap
> +	 * Magnetics
> +	 */
> +	ret = phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> +			   LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG);

Error handling? If this returns a negative error code, then the if()
statement likely becomes true... although the writes below may also
error out.

> +	if (ret & LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG_MAGJACK) {
> +		phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +			      LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT,
> +			      LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT_VAL);
> +		phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +			      LAN8841_BTRX_POWER_DOWN,
> +			      LAN8841_BTRX_POWER_DOWN_QBIAS_CH_A |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_A |
> +			      LAN8841_BTRX_POWER_DOWN_QBIAS_CH_B |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_B |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_C |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_D);
> +	}
> +
> +	/* LDO Adjustment errata */
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_11,
> +		      LAN8841_ANALOG_CONTROL_11_LDO_REF(1));
> +
> +	/* 100BT RGMII latency tuning errata */
> +	phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
> +		      LAN8841_ADC_CHANNEL_MASK, 0x0);
> +	phy_write_mmd(phydev, LAN8841_MMD_TIMER_REG,
> +		      LAN8841_MMD0_REGISTER_17,
> +		      LAN8841_MMD0_REGISTER_17_DROP_OPT(2) |
> +		      LAN8841_MMD0_REGISTER_17_XMIT_TOG_TX_DIS);
> +
> +	return 0;

This function is always succesful, even if the writes fail?

> +}
> +
> +#define LAN8841_OUTPUT_CTRL			25
> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER		BIT(14)
> +#define LAN8841_CTRL				31
> +#define LAN8841_CTRL_INTR_POLARITY		BIT(14)
> +static int lan8841_config_intr(struct phy_device *phydev)
> +{
> +	struct irq_data *irq_data;
> +	int temp = 0;
> +
> +	irq_data = irq_get_irq_data(phydev->irq);
> +	if (!irq_data)
> +		return 0;
> +
> +	if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> +		/* Change polarity of the interrupt */
> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER);
> +		phy_modify(phydev, LAN8841_CTRL,
> +			   LAN8841_CTRL_INTR_POLARITY,
> +			   LAN8841_CTRL_INTR_POLARITY);
> +	} else {
> +		/* It is enough to set INT buffer to open-drain because then
> +		 * the interrupt will be active low.
> +		 */
> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> +	}
> +
> +	/* enable / disable interrupts */
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		temp = LAN8814_INT_LINK;
> +
> +	return phy_write(phydev, LAN8814_INTC, temp);
> +}
> +
> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status;
> +
> +	irq_status = phy_read(phydev, LAN8814_INTS);
> +	if (irq_status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (irq_status & LAN8814_INT_LINK) {
> +		phy_trigger_machine(phydev);
> +		return IRQ_HANDLED;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
> +static int lan8841_probe(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = kszphy_probe(phydev);
> +	if (err)
> +		return err;
> +
> +	if (phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> +			 LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER) &
> +	    LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN)
> +		phydev->interface = PHY_INTERFACE_MODE_RGMII_RXID;

I'm not entirely sure what this code is trying to do here, as many
drivers just pass into phy_attach_direct() the interface mode that
was configured in firmware or by the ethernet driver's platform
data, and that will override phydev->interface.

There are a few corner cases in DSA where we do make use of the
phy's ->interface as set at probe() time but that's rather
exceptional.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
