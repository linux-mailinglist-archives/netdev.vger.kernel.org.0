Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78946320490
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 10:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhBTJFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 04:05:09 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:56342 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 04:03:54 -0500
Date:   Sat, 20 Feb 2021 12:02:48 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
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
Message-ID: <20210220090248.oiyonlfucvmgzw6d@mobilestation>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
 <20210210164720.migzigazyqsuxwc6@mobilestation>
 <20210211103941.GW1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210211103941.GW1463@shell.armlinux.org.uk>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 10:39:41AM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Feb 10, 2021 at 07:47:20PM +0300, Serge Semin wrote:
> > On Tue, Feb 09, 2021 at 10:56:46AM +0000, Russell King - ARM Linux admin wrote:
> > > On Tue, Feb 09, 2021 at 11:37:29AM +0100, Heiner Kallweit wrote:
> > > > Right, adding something like a genphy_{read,write}_mmd() doesn't make
> > > > too much sense for now. What I meant is just exporting mmd_phy_indirect().
> > > > Then you don't have to open-code the first three steps of a mmd read/write.
> > > > And it requires no additional code in phylib.
> > > 
> > > ... but at the cost that the compiler can no longer inline that code,
> > > as I mentioned in my previous reply. (However, the cost of the accesses
> > > will be higher.) On the plus side, less I-cache footprint, and smaller
> > > kernel code.
> > 
> > Just to note mmd_phy_indirect() isn't defined with inline specifier,
> > but just as static and it's used twice in the
> > drivers/net/phy/phy-core.c unit. So most likely the compiler won't
> > inline the function code in there.
> 
> You can't always tell whether the compiler will inline a static function
> or not.

Andrew, Heiner, Russell, what is your final decision about this? Shall
we export the mmd_phy_indirect() method, implement new
genphy_{read,write}_mmd() or just leave the patch as is manually
accessing the MMD register in the driver?

-Sergey

> 
> > Anyway it's up to the PHY
> > library maintainers to decide. Please settle the issue with Heiner and
> > Andrew then. I am ok with both solutions and will do as you decide.
> 
> FYI, *I* am one of the phylib maintainers.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
