Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345B2FF01F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbhAUQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:24:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52774 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731930AbhAUQX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 11:23:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2cjF-001r0Z-GH; Thu, 21 Jan 2021 17:22:37 +0100
Date:   Thu, 21 Jan 2021 17:22:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <YAmqTUdMXOmd/rYI@lunn.ch>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
 <20210121150611.GA20321@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121150611.GA20321@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 07:06:11AM -0800, Richard Cochran wrote:
> On Thu, Jan 21, 2021 at 10:27:38AM +0000, Russell King - ARM Linux admin wrote:
> > As I already explained to you, you can *NOT* use kernel configuration
> > to make the choice.  ARM is a multi-platform kernel, and we will not
> > stand for platform choices dictated by kernel configuration options.
> 
> This has nothing to do with ARM as a platform.  The same limitation
> applies to x86 and all the rest.
> 
> The networking stack does not support simultaneous PHY and MAC time
> stamping.

Hi Richard

And this appears to be the crux of the problem.

You say PHY timestamping is exotic. I would disagree with that.  Many
Marvell PHYs support it, using similar hardware as to what is in the
Marvell DSA switches. The Aquantia PHYs support it, but have no driver
support at the moment. Microsemi PHYs have driver support for
it. There are Broadcom PHYs with the needed hardware. So does some of
the Qualcom PHYs. There are automotive T1 PHYs with PTP hardware
support. Some Realtek devices have the hardware.

There is a growing interesting in PTP, the number of drivers keeps
going up. The likelihood of MAC/PHY combination having two
timestamping sources is growing all the time. So the stack needs to
change to support the selection of the timestamp source.

       Andrew
