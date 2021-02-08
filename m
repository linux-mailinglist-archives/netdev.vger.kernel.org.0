Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55633137C5
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhBHPa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:30:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233917AbhBHP2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l98Rs-004rNB-AA; Mon, 08 Feb 2021 16:27:36 +0100
Date:   Mon, 8 Feb 2021 16:27:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <YCFYaFYgFikj/Gqz@lunn.ch>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:03:22PM +0300, Serge Semin wrote:
> It has been noticed that RTL8211E PHY stops detecting and reporting events
> when EEE is successfully advertised and RXC stopping in LPI is enabled.
> The freeze happens right after 3.0.10 bit (PC1R "Clock Stop Enable"
> register) is set. At the same time LED2 stops blinking as if EEE mode has
> been disabled. Notably the network traffic still flows through the PHY
> with no obvious problem. Anyway if any MDIO read procedure is performed
> after the "RXC stop in LPI" mode is enabled PHY gets to be unfrozen, LED2
> starts blinking and PHY interrupts happens again. The problem has been
> noticed on RTL8211E PHY working together with DW GMAC 3.73a MAC and
> reporting its event via a dedicated IRQ signal. (Obviously the problem has
> been unnoticed in the polling mode, since it gets naturally fixed by the
> periodic MDIO read procedure from the PHY status register - BMSR.)
> 
> In order to fix that problem we suggest to locally re-implement the MMD
> write method for RTL8211E PHY and perform a dummy read right after the
> PC1R register is accessed to enable the RXC stopping in LPI mode.

Hi Serge

Is this listed in an Errata from Realtek?

   Andrew
