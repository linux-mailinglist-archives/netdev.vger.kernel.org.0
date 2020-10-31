Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1312A1559
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJaK51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgJaK50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 06:57:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434B2C0613D5;
        Sat, 31 Oct 2020 03:57:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a15so471304edy.1;
        Sat, 31 Oct 2020 03:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s1a4ay/ZA0139gaJG0Uz6JXksI84uELFZprIp8P1IZo=;
        b=VRYPTPDho0rY696UeWs18IoBEPS9mNGREkTWV2t8/nPYb28kBWAdhFupECptmg2jsW
         11pvQmv2uXiTnXNtelu7oC3J0+9G+Ec9mxmUcnDdsEVsxhNSG+tRFCU6HCYyg0lbnVf4
         3WLgFCXJJy+uh7eim9+rbCv+fNfRz2I169vYvaJMw8sByZu1uZ7hxMr1BwvH2pi5oOJv
         JnulK6G6/fnnmCcEIkVmD7lrG5MkzFlc/z9vy4Pikj1/hxdqMPzAApg/1kz3slXOeJU0
         XxawtTbFPgx9toR/9h9dMWP7yhn39hifcxJJe0Wu/gel41qWmBFvQAZjmbkmpXtDeN3N
         xw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s1a4ay/ZA0139gaJG0Uz6JXksI84uELFZprIp8P1IZo=;
        b=sFYJYXqVnRZB1AKape6XuoArCCV0xPuM76u09hbZauJVPrMcHvCcbjiGVdyIDoCohE
         XSFubXu8YnJ586BZ1WZKzbfhrRVTSRHUSIHOCXmZFn5z0xFuPNOhWVm/idHUfcU5LNCg
         1b2vSR1nlP4bhbR67FjPgFW802NREbfYXOpwcXaUKVUX1Ubs0en6Wps/rhiAmw254Zvk
         LuRrDzd6EwUirYFuTZ82AfwQSqR/GNBLppjYBFMl7HWp+wiEgUN0C9K8goDO2EBZDvYI
         sObP1PnkyZD4buOhmUFOnjfLSNZaP5k15CxP9swDy/8yYjNraVK2OG/oNrViw/hlIirk
         Jn3g==
X-Gm-Message-State: AOAM532IavXFkK8CO0AP66eUR1vUyqkQAeiwi19aklo33GEkfR13h3sJ
        g0U/VUkk6BCE64dMlT7cj7c=
X-Google-Smtp-Source: ABdhPJyvGmiTRz/IG4LB0Xg65JyaYC0OvkWHo7XfiZEZoSxzKiZsM23Pvbuny9RXfTkiiOpTZvx2AQ==
X-Received: by 2002:a50:eb0a:: with SMTP id y10mr7378971edp.342.1604141844993;
        Sat, 31 Oct 2020 03:57:24 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rn2sm245144ejb.94.2020.10.31.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 03:57:24 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 12:57:21 +0200
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20201031105721.cc5g3he66ku6rm5b@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
 <20201030233627.GA1054829@lunn.ch>
 <fee0997d-f4bc-dfc3-9423-476f04218614@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fee0997d-f4bc-dfc3-9423-476f04218614@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:18:18AM +0100, Heiner Kallweit wrote:
> On 31.10.2020 00:36, Andrew Lunn wrote:
> >>> - Every PHY driver gains a .handle_interrupt() implementation that, for
> >>>   the most part, would look like below:
> >>>
> >>> 	irq_status = phy_read(phydev, INTR_STATUS);
> >>> 	if (irq_status < 0) {
> >>> 		phy_error(phydev);
> >>> 		return IRQ_NONE;
> >>> 	}
> >>>
> >>> 	if (irq_status == 0)
> >>
> >> Here I have a concern, bits may be set even if the respective interrupt
> >> source isn't enabled. Therefore we may falsely blame a device to have
> >> triggered the interrupt. irq_status should be masked with the actually
> >> enabled irq source bits.
> > 
> > Hi Heiner
> > 
> Hi Andrew,
> 
> > I would say that is a driver implementation detail, for each driver to
> > handle how it needs to handle it. I've seen some hardware where the
> > interrupt status is already masked with the interrupt enabled
> > bits. I've soon other hardware where it is not.
> > 
> Sure, I just wanted to add the comment before others simply copy and
> paste this (pseudo) code. And in patch 9 (aquantia) and 18 (realtek)
> it is used as is. And IIRC at least the Aquantia PHY doesn't mask
> the interrupt status.
> 

Hi Heiner,

If I understand correctly what you are suggesting, the
.handle_interrupt() for the aquantia would look like this:

static irqreturn_t aqr_handle_interrupt(struct phy_device *phydev)
{
	int irq_status;

	irq_status = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
	if (irq_status < 0) {
		phy_error(phydev);
		return IRQ_NONE;
	}

	if (!(irq_status & MDIO_AN_TX_VEND_INT_STATUS2_MASK))
		return IRQ_NONE;

	phy_trigger_machine(phydev);

	return IRQ_HANDLED;
}

So only return IRQ_HANDLED when one of the bits from INT_STATUS
corresponding with the enabled interrupts are set, not if any other link
status bit is set.

Ok, I'll send a v2 with these kind of changes.

Ioana
