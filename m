Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2B12DAE6D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLON7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:59:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbgLON7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 08:59:30 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpAqb-00C52E-Nu; Tue, 15 Dec 2020 14:58:37 +0100
Date:   Tue, 15 Dec 2020 14:58:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] net: stmmac: Problem with adding the native GPIOs support
Message-ID: <20201215135837.GB2822543@lunn.ch>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
 <20201214153143.GB2841266@lunn.ch>
 <20201215082527.lqipjzastdlhzkqv@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215082527.lqipjzastdlhzkqv@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Anyway the hardware setup depicted above doesn't seem
> > > problematic at the first glance, but in fact it is. See, the DW *MAC driver
> > > (STMMAC ethernet driver) is doing the MAC reset each time it performs the
> > > device open or resume by means of the call-chain:
> > > 
> > >   stmmac_open()---+
> > >                   +->stmmac_hw_setup()->stmmac_init_dma_engine()->stmmac_reset().
> > >   stmmac_resume()-+
> > > 
> > > Such reset causes the whole interface reset: MAC, DMA and, what is more
> > > important, GPIOs as being exposed as part of the MAC registers. That
> > > in our case automatically causes the external PHY reset, what neither
> > > the STTMAC driver nor the PHY subsystem expect at all.
> > 
> 
> > Is the reset of the GPIO sub block under software control? When you
> > have a GPIO controller implemented, you would want to disable this.
> 
> Not sure I've fully understood your question. The GPIO sub-block of
> the MAC is getting reset together with the MAC.

And my question is, is that under software control, or is the hardware
synthesised so that the GPIO controller is reset as part of the MAC
reset?

From what you are saying, it sounds like from software you cannot
independently control the GPIO controller reset?

This is something i would be asking the hardware people. Look at the
VHDL, etc.

      Andrew
