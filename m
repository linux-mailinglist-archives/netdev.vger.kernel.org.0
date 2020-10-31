Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5E22A137D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 06:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgJaFXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 01:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJaFXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 01:23:04 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98715C0613D5;
        Fri, 30 Oct 2020 22:23:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so11475382eji.4;
        Fri, 30 Oct 2020 22:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1foCDvqNp97coSLrJHBgUrErmgwaD7+Kay2OQmrpnWM=;
        b=Tesbq+uxd7lnbEn16lk3Zk+u3qNWPtupkfDYn7+ZoeaISm1WbMjw9L6CYwy+Jy2p/x
         3DEMiIDSxAjmAgEE7FB90eslRvF2P35DhnxhPKC13YWNu+ZOtlo8NJIb5gmbBViWXZ6J
         nfL1x8sedGwmgWCE6RUTUPmSlcvSk77ZtbJXFPUPCZnQ8FRozTHYhlYMu6rx6gqkPP5j
         Ibundcz0XC78XVw8L5eJI7G0y7UBNK9WnFr7pIYbwfIGvfpBmFddw4/NUSUzeK8KledF
         yiav5nfCm5ZPvtqqHH59LJArvK1AsQdWOgbZzam4+aXCAkJylaoP+qVTn4mHSu7TygBn
         nPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1foCDvqNp97coSLrJHBgUrErmgwaD7+Kay2OQmrpnWM=;
        b=fV72RQ9yjqylqt895IbeqEMelGxfF9sUEMxynuIR+q43VzhKvHgKoGxIy5+4P/236u
         m4B3b4NYhnHMe1CnuYneE7uLlkKRosNoD7CfHs4HR5XBNZ5zUVmIHTfbMwjSG/fv+aCc
         y0LoTU/tRtdEe6FDiFFuUamZVIJcUeHvaP1I2ow3hlVCRDOSgDpvEg9/cAP1gvgPOH1P
         wmq3drAJHZ/aZ5klhcFF76JMHrvZXci5zH/6XsdmuX30kC2mJViHByv8ML9lCtr09WOg
         GznAb96tfxCZptP9WhKDzBipUiWnDM4MJPYT9qzf2pAaNVw5pnotoJPWRJsL2Mxz5Q7k
         ljxg==
X-Gm-Message-State: AOAM533cjs9upJK4jm6hsnqCAAVEZYKc2bejfl6xg2+3JVDWF5tJQ+JY
        DIfiabP55cDShO7SwqI2XjM=
X-Google-Smtp-Source: ABdhPJx2r0Eed6DkEXnT1mhM3h+19x4eiwrtQAksDjbdA9oIUeKgcqIw09z3G8lC1OIzCSadUSOR8A==
X-Received: by 2002:a17:906:7096:: with SMTP id b22mr6089563ejk.335.1604121783156;
        Fri, 30 Oct 2020 22:23:03 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id x2sm4087695edr.65.2020.10.30.22.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 22:23:02 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 07:22:59 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
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
Message-ID: <20201031052259.pmhkmlaq5sqndtwu@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
 <20201030233627.GA1054829@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030233627.GA1054829@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 12:36:27AM +0100, Andrew Lunn wrote:
> > > - Every PHY driver gains a .handle_interrupt() implementation that, for
> > >   the most part, would look like below:
> > > 
> > > 	irq_status = phy_read(phydev, INTR_STATUS);
> > > 	if (irq_status < 0) {
> > > 		phy_error(phydev);
> > > 		return IRQ_NONE;
> > > 	}
> > > 
> > > 	if (irq_status == 0)
> > 
> > Here I have a concern, bits may be set even if the respective interrupt
> > source isn't enabled. Therefore we may falsely blame a device to have
> > triggered the interrupt. irq_status should be masked with the actually
> > enabled irq source bits.
> 
> Hi Heiner
> 
> I would say that is a driver implementation detail, for each driver to
> handle how it needs to handle it. I've seen some hardware where the
> interrupt status is already masked with the interrupt enabled
> bits. I've soon other hardware where it is not.
> 
> For example code, what is listed above is O.K. The real implementation
> in a driver need knowledge of the hardware.
> 

Hi,

As Andrew said, that is just an example code that could work for some
devices but should be extended depending on how the actual PHY is
working.

For example, the VSC8584 will still be trigerring the link state machine
just on the link change interrupt, I am not changing this:

static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
{
	irqreturn_t ret;
	int irq_status;

	irq_status = phy_read(phydev, MII_VSC85XX_INT_STATUS);
	if (irq_status < 0)
		return IRQ_NONE;

	/* Timestamping IRQ does not set a bit in the global INT_STATUS, so
	 * irq_status would be 0.
	 */
	ret = vsc8584_handle_ts_interrupt(phydev);
	if (!(irq_status & MII_VSC85XX_INT_MASK_MASK))
		return ret;

	if (irq_status & MII_VSC85XX_INT_MASK_EXT)
		vsc8584_handle_macsec_interrupt(phydev);

	if (irq_status & MII_VSC85XX_INT_MASK_LINK_CHG)
		phy_trigger_machine(phydev);

	return IRQ_HANDLED;
}

Ioana
