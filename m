Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862C12E0F93
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgLVVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:01:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgLVVBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:01:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krolm-00DS6O-5t; Tue, 22 Dec 2020 22:00:34 +0100
Date:   Tue, 22 Dec 2020 22:00:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hongwei Zhang <hongweiz@ami.com>, linux-aspeed@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: Re: [Aspeed, v2 2/2] net: ftgmac100: Change the order of getting MAC
 address
Message-ID: <20201222210034.GC3198262@lunn.ch>
References: <20201221205157.31501-2-hongweiz@ami.com>
 <20201222201437.5588-3-hongweiz@ami.com>
 <96c355a2-ab7e-3cf0-57e7-16369da78035@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c355a2-ab7e-3cf0-57e7-16369da78035@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 09:46:52PM +0100, Heiner Kallweit wrote:
> On 22.12.2020 21:14, Hongwei Zhang wrote:
> > Dear Reviewer,
> > 
> > Use native MAC address is preferred over other choices, thus change the order
> > of reading MAC address, try to read it from MAC chip first, if it's not
> >  availabe, then try to read it from device tree.
> > 
> > 
> > Hi Heiner,
> > 
> >> From:	Heiner Kallweit <hkallweit1@gmail.com>
> >> Sent:	Monday, December 21, 2020 4:37 PM
> >>> Change the order of reading MAC address, try to read it from MAC chip 
> >>> first, if it's not availabe, then try to read it from device tree.
> >>>
> >> This commit message leaves a number of questions. It seems the change isn't related at all to the 
> >> change that it's supposed to fix.
> >>
> >> - What is the issue that you're trying to fix?
> >> - And what is wrong with the original change?
> > 
> > There is no bug or something wrong with the original code. This patch is for
> > improving the code. We thought if the native MAC address is available, then
> > it's preferred over MAC address from dts (assuming both sources are available).
> > 
> > One possible scenario, a MAC address is set in dts and the BMC image is 
> > compiled and loaded into more than one platform, then the platforms will
> > have network issue due to the same MAC address they read.
> > 
> 
> Typically the DTS MAC address is overwritten by the boot loader, e.g. uboot.
> And the boot loader can read it from chip registers. There are more drivers
> trying to read the MAC address from DTS first. Eventually, I think, the code
> here will read the same MAC address from chip registers as uboot did before.

Do we need to worry about, the chip contains random junk, which passes
the validitiy test? Before this patch the value from DT would be used,
and the random junk is ignored. Is this change possibly going to cause
a regression?

	Andrew
