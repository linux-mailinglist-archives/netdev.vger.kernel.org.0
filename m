Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5F368A962
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjBDKMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBDKMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:12:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CF768120;
        Sat,  4 Feb 2023 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675505557; x=1707041557;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cla41gMIi/sN/jPb/L7FCl7VivCGu8Rfj1+E/Ob5Vsw=;
  b=mSkmGLo9F3PtWayYpv4SPdCdYX//pTBT8E1LSA2kswbluL9nsWQA1xCs
   0zDHOhZKIbyw1K2/2UxKp5MSk2vaBhqEh2zYa5JYLgoXkWUUY7pz7EXhT
   3Y/ewOvLi/2VxjhprU2RJGJiZv4KimHCpZbADIwgCKwHMlcZMUv+gKvC4
   Tlcpg76JuWCafpdFPsoz0O+liB6T7dGohBxvg6zjCv1IPd/U91H0qvmx3
   /tlU8cpyifDK0j8WGO53tfRQujVPEOTh59Sbjb+KcBJ/k4zmkrxmiD8ZI
   wO1ipOvt+8LItRha6q7I/0GXaAHRJdNnDfP9xFd9LKVY8xkPje9YzmfmB
   g==;
X-IronPort-AV: E=Sophos;i="5.97,272,1669100400"; 
   d="scan'208";a="135542888"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2023 03:12:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 03:12:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Sat, 4 Feb 2023 03:12:35 -0700
Date:   Sat, 4 Feb 2023 11:12:35 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michael@walle.cc>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <20230204101235.7fk4jqditdjrqegp@soft-dev3-1>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <0f81d14d-50cb-b807-b103-8fa066d0769c@gmail.com>
 <20230203151059.k5aa6zihibgsedcw@soft-dev3-1>
 <0280ecbc-06e4-72ce-95f8-17217833c19f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <0280ecbc-06e4-72ce-95f8-17217833c19f@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/03/2023 22:57, Heiner Kallweit wrote:
> 
> On 03.02.2023 16:10, Horatiu Vultur wrote:
> > The 02/03/2023 14:55, Heiner Kallweit wrote:
> >
> > Hi Heiner,
> >
> >>
> >> On 03.02.2023 13:25, Horatiu Vultur wrote:
> >
> > ...
> >
> >>> +
> >>> +#define LAN8841_OUTPUT_CTRL                  25
> >>> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER               BIT(14)
> >>> +#define LAN8841_CTRL                         31
> >>> +#define LAN8841_CTRL_INTR_POLARITY           BIT(14)
> >>> +static int lan8841_config_intr(struct phy_device *phydev)
> >>> +{
> >>> +     struct irq_data *irq_data;
> >>> +     int temp = 0;
> >>> +
> >>> +     irq_data = irq_get_irq_data(phydev->irq);
> >>> +     if (!irq_data)
> >>> +             return 0;
> >>> +
> >>> +     if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> >>> +             /* Change polarity of the interrupt */
> >>
> >> Why this a little bit esoteric logic? Can't you set the interrupt
> >> to level-low in the chip (like most other ones), and then define
> >> the polarity the usual way e.g. in DT?
> >
> > To set the interrupt to level-low it needs to be set to open-drain and
> > in that case I can't use the polarity register, because doesn't have any
> > effect on the interrupt. So I can't set the interrupt to level low and
> > then use the polarity to select if it is high or low.
> > That is the reason why I have these checks.
> >
> To me this still doesn't look right. After checking the datasheet I'd say:
> At first open-drain should be preferred because only in this mode the
> interrupt line can be shared.

Agree.

> And if you use level-low and open-drain, why would you want to fiddle
> with the polarity?

In this case, I don't fiddle with the polarity. That case is on the else
branch of this if condition. I play with the polarity only when using
push-pull.

> Level-low and open-drain is the only mode supported by
> most PHY's and it's totally fine.
>
> Or do you have a special use case where
> you want to connect the interrupt pin to an interrupt controller that
> only supports level-high and has no programmable inverter in its path?

I have two cases:
1. When lan966x is connected to this lan8841. In this case the interrupt
controller supports both level-low and level-high. But in this case I
can test only the level-low.

2. When lan7431 is connected to this lan8841 and using x86. If I
remember correctly (I don't have the setup to test it anymore and will
take a some time to get it again) this worked only with level-high
interrupts. To get this working I had some changes in the lan7431 driver
to enable interrupts from the external PHY.

Maybe a better approach would be for now, just to set the interrupt to
open-drain in the lan8841. And only when I add the changes to lan7431
also add the changes to lan8841 to support level-high interrupts if it
is still needed.

> 
> >>
> >>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> >>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER,
> >>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER);
> >>> +             phy_modify(phydev, LAN8841_CTRL,
> >>> +                        LAN8841_CTRL_INTR_POLARITY,
> >>> +                        LAN8841_CTRL_INTR_POLARITY);
> >>> +     } else {
> >>> +             /* It is enough to set INT buffer to open-drain because then
> >>> +              * the interrupt will be active low.
> >>> +              */
> >>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> >>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> >>> +     }
> >>> +
> >>> +     /* enable / disable interrupts */
> >>> +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> >>> +             temp = LAN8814_INT_LINK;
> >>> +
> >>> +     return phy_write(phydev, LAN8814_INTC, temp);
> >>> +}
> >>> +
> >>> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> >>> +{
> >>> +     int irq_status;
> >>> +
> >>> +     irq_status = phy_read(phydev, LAN8814_INTS);
> >>> +     if (irq_status < 0) {
> >>> +             phy_error(phydev);
> >>> +             return IRQ_NONE;
> >>> +     }
> >>> +
> >>> +     if (irq_status & LAN8814_INT_LINK) {
> >>> +             phy_trigger_machine(phydev);
> >>> +             return IRQ_HANDLED;
> >>> +     }
> >>> +
> >>> +     return IRQ_NONE;
> >>> +}
> >>> +
> >
> 

-- 
/Horatiu
