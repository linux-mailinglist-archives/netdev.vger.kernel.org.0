Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526D81A478D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 16:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgDJOhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 10:37:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33980 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgDJOhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 10:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Am4Ycms2POwTQ12qgpIAF8NR2XNycrWuWB6VikOBP70=; b=sE9KsPtcvrEzyhobnkuYZ3ijH
        o+px0UY5hpHLEy0zYcnM9KI6elAtqKxhqwwHWJ2x0giOOKSNs3h3d/dbTy/V0Szu4p5ED205P/r8L
        g0Hza95uT1MI1HmGGMvrz7tLevhork4ocw0GS6ILu8D4KPLyddryVmmIKts4yvzr70GDWfoUnhB3d
        Tin3Dk8z7AWCNZT4AgTScpn0dXAa6duW7NI/tpq5OP7IKTXOUmMBGRl67H4V3KzdjtuA7BgIPTRc7
        1UVD9ibuQfIX7Kcy7x16APeeqWvnjS8/xAEGGR4RPJ7Gb5mYvu+lrZc3U7TZ5gYLTfNXgC7HYTL9E
        Jnh9OSkzw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44070)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jMumB-000210-Oo; Fri, 10 Apr 2020 15:36:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jMumA-0003qU-58; Fri, 10 Apr 2020 15:36:58 +0100
Date:   Fri, 10 Apr 2020 15:36:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200410143658.GM5827@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410141914.GY25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 03:19:14PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> > On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > >
> > > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > > about 10% of the board idle power.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Hi,
> > 
> > I have a Macchiatobin double shot, and my 10G ports stop working after
> > this change.
> > I reverted this commit on top of latest net-next and now the ports work again.
> 
> Please describe the problem in more detail.
> 
> Do you have the interface up?  Does the PHY link with the partner?
> Is the problem just that traffic isn't passed?

I've just retested on my Macchiatobin double shot, and it works fine.
What revision PHYs do you have?  Unfortunately, you can't read the
PHY ID except using mii-diag:

# mii-diag eth0 -p 32769

or

# mii-diag eth1 -p 33025

Looking at word 3 and 4, it will be either:

002b 09aa
002b 09ab

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
