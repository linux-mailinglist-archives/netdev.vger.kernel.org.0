Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6148648B5DB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbiAKSlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:41:06 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:42571 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbiAKSlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:41:05 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 56941240006;
        Tue, 11 Jan 2022 18:41:01 +0000 (UTC)
Date:   Tue, 11 Jan 2022 19:41:00 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <Yd3PPMOAcwRS6SlF@piout.net>
References: <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
 <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
 <Yd1YV+eUIaCnttYd@google.com>
 <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
 <20220111165330.GA28004@COLIN-DESKTOP1.localdomain>
 <Yd23m1WH80qB5wsU@google.com>
 <20220111182815.GC28004@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220111182815.GC28004@COLIN-DESKTOP1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 10:28:15-0800, Colin Foster wrote:
> At the same time, mscc-miim can be probed independently, at which point it
> would create a smaller regmap at 0x7107009c
> (Documentation/devicetree/bindings/mscc-miim.txt)
> 
> So the mscc-miim driver supports multiple use-cases. I expect the same
> type of "offset" idea can be reasonably added to the following drivers,
> all of which already exist but need to support the same type of
> use-case:
> 
> mscc,ocelot-pinctrl, mscc,ocelot-sgpio, mscc,ocelot-miim, and
> mscc,vsc7514-serdes. As I'm bringing up different parts of the hardware,
> there might be more components that become necessary.

Indeed, I guess at some point you'll need the irqchip driver too. Until
now, what I did was handling the irq controller inside the mfd driver as
reusing the irqchip driver is not trivial. Ths create a bit of code
duplication but it is not that bad.

> 
> With the exception of vsc7514-serdes, those all exist outside of MFD.
> The vsc7512-serdes driver currently relies on syscon / MFD, which adds a
> different complexity. One that I think probably merits a separate probe
> function.
> 
> > 
> > -- 
> > Lee Jones [李琼斯]
> > Principal Technical Lead - Developer Services
> > Linaro.org │ Open source software for Arm SoCs
> > Follow Linaro: Facebook | Twitter | Blog

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
