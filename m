Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585F16919DE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBJIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjBJINW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:13:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8026C1714;
        Fri, 10 Feb 2023 00:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676016777; x=1707552777;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EddZV24SO30mxXM4gdajbHrZf4L4SPHAiczim8swLz8=;
  b=KE4a7nrSP6ZEuV6DTOjisFH9u3muUBTGvr0WNBBx0ZrhSCJY+v9aG7fk
   HT6XsqgkM4CXWg0ucDRSj8IBsL9CW7G5KnywFR13Y7GXXJQ0R9AzCWjA5
   4yNnXlE/NNT5kxG1Ux/sPp+Pg+BrW/eDdPGsPGHUgWWBYxMAZerH3XTeW
   CA4jtBhs0ooiccozMYGS5z3T3T17iyXHgC08Sge4uZmMVa9h8IYiqZc9E
   YtE5bKKCS+SQEsxq6B64xJ+AQEvvfZEytXlYY7RBPgWWNTP+8zHeHEZYL
   SmNf+FRpLQskr5ohK82xmvTTemgmbr3x4F3HPtHzekQlGKG8x05CpVu7r
   w==;
X-IronPort-AV: E=Sophos;i="5.97,286,1669100400"; 
   d="scan'208";a="136505479"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2023 01:12:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 01:12:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 10 Feb 2023 01:12:36 -0700
Date:   Fri, 10 Feb 2023 09:12:35 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michael@walle.cc>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <20230210081235.aodynjzalhbaaxby@soft-dev3-1>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <Y+UhP1Ycq8a8RWJr@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y+UhP1Ycq8a8RWJr@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/09/2023 16:37, Russell King (Oracle) wrote:

Hi Russell,

Thanks for the review. The latest version of this patch series (v4) was
already accepted. But your comments will still apply.

> 
> On Fri, Feb 03, 2023 at 01:25:42PM +0100, Horatiu Vultur wrote:
> > +hw_init:
> > +     /* 100BT Clause 40 improvenent errata */
> > +     phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> > +                   LAN8841_ANALOG_CONTROL_1,
> > +                   LAN8841_ANALOG_CONTROL_1_PLL_TRIM(0x2));
> > +     phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> > +                   LAN8841_ANALOG_CONTROL_10,
> > +                   LAN8841_ANALOG_CONTROL_10_PLL_DIV(0x1));
> > +
> > +     /* 10M/100M Ethernet Signal Tuning Errata for Shorted-Center Tap
> > +      * Magnetics
> > +      */
> > +     ret = phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> > +                        LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG);
> 
> Error handling? If this returns a negative error code, then the if()
> statement likely becomes true... although the writes below may also
> error out.

Yes, I missed that. I will add that.

> 
> > +     if (ret & LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG_MAGJACK) {
> > +             phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> > +                           LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT,
> > +                           LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT_VAL);
> > +             phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> > +                           LAN8841_BTRX_POWER_DOWN,
> > +                           LAN8841_BTRX_POWER_DOWN_QBIAS_CH_A |
> > +                           LAN8841_BTRX_POWER_DOWN_BTRX_CH_A |
> > +                           LAN8841_BTRX_POWER_DOWN_QBIAS_CH_B |
> > +                           LAN8841_BTRX_POWER_DOWN_BTRX_CH_B |
> > +                           LAN8841_BTRX_POWER_DOWN_BTRX_CH_C |
> > +                           LAN8841_BTRX_POWER_DOWN_BTRX_CH_D);
> > +     }
> > +
> > +     /* LDO Adjustment errata */
> > +     phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> > +                   LAN8841_ANALOG_CONTROL_11,
> > +                   LAN8841_ANALOG_CONTROL_11_LDO_REF(1));
> > +
> > +     /* 100BT RGMII latency tuning errata */
> > +     phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
> > +                   LAN8841_ADC_CHANNEL_MASK, 0x0);
> > +     phy_write_mmd(phydev, LAN8841_MMD_TIMER_REG,
> > +                   LAN8841_MMD0_REGISTER_17,
> > +                   LAN8841_MMD0_REGISTER_17_DROP_OPT(2) |
> > +                   LAN8841_MMD0_REGISTER_17_XMIT_TOG_TX_DIS);
> > +
> > +     return 0;
> 
> This function is always succesful, even if the writes fail?

What is the rule of thumb here? Do we need to check the return value of
the writes and reads? Because I can see in the micrel.c this is not
really the case.
> 
> > +}
> > +
> > +#define LAN8841_OUTPUT_CTRL                  25
> > +#define LAN8841_OUTPUT_CTRL_INT_BUFFER               BIT(14)
> > +#define LAN8841_CTRL                         31
> > +#define LAN8841_CTRL_INTR_POLARITY           BIT(14)
> > +static int lan8841_config_intr(struct phy_device *phydev)
> > +{
> > +     struct irq_data *irq_data;
> > +     int temp = 0;
> > +
> > +     irq_data = irq_get_irq_data(phydev->irq);
> > +     if (!irq_data)
> > +             return 0;
> > +
> > +     if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> > +             /* Change polarity of the interrupt */
> > +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER);
> > +             phy_modify(phydev, LAN8841_CTRL,
> > +                        LAN8841_CTRL_INTR_POLARITY,
> > +                        LAN8841_CTRL_INTR_POLARITY);
> > +     } else {
> > +             /* It is enough to set INT buffer to open-drain because then
> > +              * the interrupt will be active low.
> > +              */
> > +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> > +     }
> > +
> > +     /* enable / disable interrupts */
> > +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> > +             temp = LAN8814_INT_LINK;
> > +
> > +     return phy_write(phydev, LAN8814_INTC, temp);
> > +}
> > +
> > +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> > +{
> > +     int irq_status;
> > +
> > +     irq_status = phy_read(phydev, LAN8814_INTS);
> > +     if (irq_status < 0) {
> > +             phy_error(phydev);
> > +             return IRQ_NONE;
> > +     }
> > +
> > +     if (irq_status & LAN8814_INT_LINK) {
> > +             phy_trigger_machine(phydev);
> > +             return IRQ_HANDLED;
> > +     }
> > +
> > +     return IRQ_NONE;
> > +}
> > +
> > +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
> > +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
> > +static int lan8841_probe(struct phy_device *phydev)
> > +{
> > +     int err;
> > +
> > +     err = kszphy_probe(phydev);
> > +     if (err)
> > +             return err;
> > +
> > +     if (phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> > +                      LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER) &
> > +         LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN)
> > +             phydev->interface = PHY_INTERFACE_MODE_RGMII_RXID;
> 
> I'm not entirely sure what this code is trying to do here, as many
> drivers just pass into phy_attach_direct() the interface mode that
> was configured in firmware or by the ethernet driver's platform
> data, and that will override phydev->interface.

This was something when the lan8841 is connected with lan743x. The
changes to lan743x were not upstream. In that case actually it was
passing phy's->interface to the phy_attach_direct. So the interface was
not overridden.
Like I suggested to Heiner, maybe I should drop this and add back this
only when adding the changes to lan743x if it is still needed.

> 
> There are a few corner cases in DSA where we do make use of the
> phy's ->interface as set at probe() time but that's rather
> exceptional.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
