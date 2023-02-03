Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1E6890F3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjBCHfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCHfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:35:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2260792C3B;
        Thu,  2 Feb 2023 23:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675409713; x=1706945713;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ESdOtt6K+XyRU8v9/0dAjPldkqJQ08XDTbvOJerML84=;
  b=h3P+MdxgONyVnIGWC/l/c9SfKJQCtYePEGVcTIOiePxURMqrJ1b6xOEI
   xDe8s0kwmdXTj3+2tsa/UB68FZu543lvsJzha3C+Xy9Bkwl8VWEjAfkQD
   +9g8L8cPrt5ZroAGDBUAGmBABC55POCcJk/JYtYkVow1Legb6Qq8jhJii
   UINS3TjJ5o8qnUDYsPmmMLJE9wuH3AiYgE+Xg5aXYbXqLYcqorHRktiBV
   efWjpbMKjwT2JLQ5/p9wdyfnNlGIAKSop1uEInQNEWxIuuta1Fi1RjAZj
   BmCdfRft02VXSkN573XpArtaKvriAEsZcKdbDKaNj+kTYooG0wN5ahDN9
   w==;
X-IronPort-AV: E=Sophos;i="5.97,269,1669100400"; 
   d="scan'208";a="199182632"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 00:35:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:35:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 3 Feb 2023 00:35:12 -0700
Date:   Fri, 3 Feb 2023 08:35:11 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>
Subject: Re: [PATCH net-next] net: micrel: Add support for lan8841 PHY
Message-ID: <20230203073511.5qsj35xgewmcnva2@soft-dev3-1>
References: <20230202094704.175665-1-horatiu.vultur@microchip.com>
 <Y9u+UNHht9OAhKHv@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y9u+UNHht9OAhKHv@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/02/2023 14:44, Andrew Lunn wrote:

Hi Andrew,

Thanks for the review.

> 
> > @@ -1172,19 +1189,18 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
> >  #define KSZ9131RN_MMD_COMMON_CTRL_REG        2
> > +     /* 100BT Clause 40 improvenent errata */
> > +     phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_1, 0x40);
> > +     phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_10, 0x1);
> 
> Please could you try to avoid magic numbers.

I will try remove all the magic numbers.
The same will apply for all the bellow comments.

> 
> > +     /* 10M/100M Ethernet Signal Tuning Errata for Shorted-Center Tap
> > +      * Magnetics
> > +      */
> > +     ret = phy_read_mmd(phydev, 2, 0x2);
> 
> KSZ9131RN_MMD_COMMON_CTRL_REG ?
> 
> > +     if (ret & BIT(14)) {
> > +             phy_write_mmd(phydev, 28,
> > +                           LAN8841_TX_LOW_I_CH_C_POWER_MANAGMENT, 0xbffc);
> > +             phy_write_mmd(phydev, 28,
> > +                           LAN8841_BTRX_POWER_DOWN, 0xaf);
> > +     }
> > +
> > +     /* LDO Adjustment errata */
> > +     phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_11, 0x1000);
> > +
> > +     /* 100BT RGMII latency tuning errata */
> > +     phy_write_mmd(phydev, 1, LAN8841_ADC_CHANNEL_MASK, 0x0);
> > +     phy_write_mmd(phydev, 0, LAN8841_MMD0_REGISTER_17, 0xa);
> 
> MDIO_MMD_PMAPMD instead of 1.
> 
> 
> > +
> > +     return 0;
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
> > +     if (phy_read_mmd(phydev, 2, LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER) &
> 
> MDIO_MMD_WIS ?
> 
>         Andrew

-- 
/Horatiu
