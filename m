Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2577316BA5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhBJQs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:48:26 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:34650 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbhBJQsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:48:14 -0500
Date:   Wed, 10 Feb 2021 19:47:20 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210210164720.migzigazyqsuxwc6@mobilestation>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210209105646.GP1463@shell.armlinux.org.uk>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:56:46AM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Feb 09, 2021 at 11:37:29AM +0100, Heiner Kallweit wrote:
> > Right, adding something like a genphy_{read,write}_mmd() doesn't make
> > too much sense for now. What I meant is just exporting mmd_phy_indirect().
> > Then you don't have to open-code the first three steps of a mmd read/write.
> > And it requires no additional code in phylib.
> 
> ... but at the cost that the compiler can no longer inline that code,
> as I mentioned in my previous reply. (However, the cost of the accesses
> will be higher.) On the plus side, less I-cache footprint, and smaller
> kernel code.

Just to note mmd_phy_indirect() isn't defined with inline specifier,
but just as static and it's used twice in the
drivers/net/phy/phy-core.c unit. So most likely the compiler won't
inline the function code in there. Anyway it's up to the PHY
library maintainers to decide. Please settle the issue with Heiner and
Andrew then. I am ok with both solutions and will do as you decide.

-Sergey

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
