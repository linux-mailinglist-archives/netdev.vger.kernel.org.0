Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7C2A13AA
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 06:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJaF1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 01:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJaF1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 01:27:13 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187AC0613D5;
        Fri, 30 Oct 2020 22:27:12 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l16so8841416eds.3;
        Fri, 30 Oct 2020 22:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FOTH5fvFazrbPFrw/apYE4vV4GHcqmKmYzodOMEl/4Q=;
        b=HpEiioAW9TVU9sNa4mVyTlUadbLkZwltRznBaOS5qsHfoRjeHUmNCOEYfvnDpASWk4
         SW8LwdR/8LXpH0+sujJKGTagtKsPdt+NBezto7XvMDWRaNK86jYKHpWRm/leJrpw49xY
         j/L+bPZ/5ouj7oAMOd8RV+zL/CXhJVy+UHo7L6GKTSGux2RWViiEzyjaouxKAWxAipd4
         x4KZ6W9mcdbEcXRF7H6zcfCIZdHuHltgsusO9wbG7ZNg2XQms7tzW5IumLhJH3OaUEGQ
         OWDBKOCYa/61yASbSegUUmBgSw0K63YRj/qJpX50WyBuOjUrqmKmIsNktu9z5R/9RvFh
         ZVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FOTH5fvFazrbPFrw/apYE4vV4GHcqmKmYzodOMEl/4Q=;
        b=h9CRn/4aQM8khelUBDneOtBoEj2iFtNCJwDGmis+bkCbAh1fUty56V+gb9v7NlHoTF
         gtNtwqCkZaYgy32FUzI0AhRZ0DDtax1VzB0IwtbfHl7AmHq6cRpgUpIhsaibzvc/cSUx
         7KcnHngdEnL3o/TOY6OTRBEi0N3jk5z+4RNsr68O5D+/PSUuiqqUsMBBGW4otwuh9Oig
         9vRgqscpL4lQ7igp1KBuYaayqttTxdwrSgyU+CoaoTprWB8emsXIbMYBlRr/d4Wtj7Ll
         YIgk/3L6ecbgxUv5OJD2oYE9PGQPvpwC8Zb5T5AzV0A2tIvHn1L45dn8Oz91nlwQSbVE
         dLzQ==
X-Gm-Message-State: AOAM532A0n5zttE1sLxUCF3r0RuwYqOGNVuxpSwh35cJoBaMAlRllo4j
        g9pNz5AmEYTNw3HK5L5wvz4=
X-Google-Smtp-Source: ABdhPJyDCCLq6R2UYlK3gcNcWMeRfJ7HZ62/GT0fWtofGOHPoX+GDx20t/pZqCEQe5BKelvlGZwd+w==
X-Received: by 2002:a50:8a02:: with SMTP id i2mr6345499edi.40.1604122031440;
        Fri, 30 Oct 2020 22:27:11 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d10sm1521199ejw.44.2020.10.30.22.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 22:27:10 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 07:27:08 +0200
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
Message-ID: <20201031052708.geep7ydfiotzdrvg@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 10:56:24PM +0100, Heiner Kallweit wrote:
> On 29.10.2020 11:07, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > This patch set aims to actually add support for shared interrupts in
> > phylib and not only for multi-PHY devices. While we are at it,
> > streamline the interrupt handling in phylib.
> > 
> > For a bit of context, at the moment, there are multiple phy_driver ops
> > that deal with this subject:
> > 
> > - .config_intr() - Enable/disable the interrupt line.
> > 
> > - .ack_interrupt() - Should quiesce any interrupts that may have been
> >   fired.  It's also used by phylib in conjunction with .config_intr() to
> >   clear any pending interrupts after the line was disabled, and before
> >   it is going to be enabled.
> > 
> > - .did_interrupt() - Intended for multi-PHY devices with a shared IRQ
> >   line and used by phylib to discern which PHY from the package was the
> >   one that actually fired the interrupt.
> > 
> > - .handle_interrupt() - Completely overrides the default interrupt
> >   handling logic from phylib. The PHY driver is responsible for checking
> >   if any interrupt was fired by the respective PHY and choose
> >   accordingly if it's the one that should trigger the link state machine.
> > 
> >>From my point of view, the interrupt handling in phylib has become
> > somewhat confusing with all these callbacks that actually read the same
> > PHY register - the interrupt status.  A more streamlined approach would
> > be to just move the responsibility to write an interrupt handler to the
> > driver (as any other device driver does) and make .handle_interrupt()
> > the only way to deal with interrupts.
> > 
> > Another advantage with this approach would be that phylib would gain
> > support for shared IRQs between different PHY (not just multi-PHY
> > devices), something which at the moment would require extending every
> > PHY driver anyway in order to implement their .did_interrupt() callback
> > and duplicate the same logic as in .ack_interrupt(). The disadvantage
> > of making .did_interrupt() mandatory would be that we are slightly
> > changing the semantics of the phylib API and that would increase
> > confusion instead of reducing it.
> > 
> > What I am proposing is the following:
> > 
> > - As a first step, make the .ack_interrupt() callback optional so that
> >   we do not break any PHY driver amid the transition.
> > 
> > - Every PHY driver gains a .handle_interrupt() implementation that, for
> >   the most part, would look like below:
> > 
> > 	irq_status = phy_read(phydev, INTR_STATUS);
> > 	if (irq_status < 0) {
> > 		phy_error(phydev);
> > 		return IRQ_NONE;
> > 	}
> > 
> > 	if (irq_status == 0)
> > 		return IRQ_NONE;
> > 
> > 	phy_trigger_machine(phydev);
> > 
> > 	return IRQ_HANDLED;
> > 
> > - Remove each PHY driver's implementation of the .ack_interrupt() by
> >   actually taking care of quiescing any pending interrupts before
> >   enabling/after disabling the interrupt line.
> > 
> > - Finally, after all drivers have been ported, remove the
> >   .ack_interrupt() and .did_interrupt() callbacks from phy_driver.
> > 
> 
> Looks good to me. The current interrupt support in phylib basically
> just covers the link change interrupt and we need more flexibility.
> 
> And even in the current limited use case we face smaller issues.
> One reason is that INTR_STATUS typically is self-clearing on read.
> phylib has to deal with the case that did_interrupt may or may not
> have read INTR_STATUS already.
> 
> I'd just like to avoid the term "shared interrupt", because it has
> a well-defined meaning. Our major concern isn't shared interrupts
> but support for multiple interrupt sources (in addition to
> link change) in a PHY.
> 

I am not going to address this part, Vladimir did a good job in the
following emails describing exactly the problem that I am trying to fix
- shared interrupts even between PHYs which are not in the same package
or even the same type of device.

> WRT implementing a shutdown hook another use case was mentioned
> recently: https://lkml.org/lkml/2020/9/30/451
> But that's not really relevant here and just fyi.
> 

I missed this thread. Thanks for the link!

Ioana
