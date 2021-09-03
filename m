Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01C24007C0
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhICWHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhICWHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 18:07:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C52C061575;
        Fri,  3 Sep 2021 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lYMnkucizHhHL8bl6S57dxpOGD95qKSgOs+9CPa0waU=; b=Dus1MKxMfi/BXYffGH1yEeYnF
        A9VlpWmG9ijp0SudJr3vXD+Y/aB/skoRNHBDARZwCEOTEE76+j3bZ4mIFqgs5UhdRBZsESU30hqc+
        n2Xln2lBAlG6hIDmoSBfMLDUvjkKDIMyPpCrHNWwOvhmMA5YZwT7aERiwhgcdVsLmP/8UrYvWPQOE
        qHNEiyptSEtQp5dViqxHbreVzgIZRzFRv/xuIE3u6rSDvWY40vyKY/Bv7awGTjYG9Ju4l3t1ICw29
        x6INddqWWA+coWgfRbg7lRH3zV0heQGeptWfDEdGt++oIZcJmxAnuwMg7JkUlrD3bgWIAIFAyxCtf
        NDRWeJWrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48188)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mMHKM-0003fS-9p; Fri, 03 Sep 2021 23:06:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mMHKJ-0000rh-SA; Fri, 03 Sep 2021 23:06:23 +0100
Date:   Fri, 3 Sep 2021 23:06:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210903220623.GA22278@shell.armlinux.org.uk>
References: <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
 <20210902232607.v7uglvpqi5hyoudq@skbuf>
 <20210903000419.GR22278@shell.armlinux.org.uk>
 <20210903204822.cachpb2uh53rilzt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903204822.cachpb2uh53rilzt@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 11:48:22PM +0300, Vladimir Oltean wrote:
> On Fri, Sep 03, 2021 at 01:04:19AM +0100, Russell King (Oracle) wrote:
> > Removing a lock and then running the kernel is a down right stupid
> > way to test to see if a lock is necessary.
> > 
> > That approach is like having built a iron bridge, covered it in paint,
> > then you remove most the bolts, and then test to see whether it's safe
> > for vehicles to travel over it by riding your bicycle across it and
> > declaring it safe.
> > 
> > Sorry, but if you think "remove lock, run kernel, if it works fine
> > the lock is unnecessary" is a valid approach, then you've just
> > disqualified yourself from discussing this topic any further.
> > Locking is done by knowing the code and code analysis, not by
> > playing "does the code fail if I remove it" games. I am utterly
> > shocked that you think that this is a valid approach.
> 
> ... and this is exactly why you will no longer get any attention from me
> on this topic. Good luck.

Good, because your approach to this to me reads as "I don't think you
know what the hell you're doing so I'm going to remove a lock to test
whether it is needed." Effectively, that action is an insult towards
me as the author of that code.

And as I said, if you think that's a valid approach, then quite frankly
I don't want you touching my code, because you clearly don't know what
you're doing as you aren't willing to put the necessary effort in to
understanding the code.

Removing a lock and running the kernel is _never_ a valid way to see
whether the lock is required or not. The only way is via code analysis.

I wonder whether you'd take the same approach with filesystems or
memory management code. Why don't you try removing some locks from
those subsystems and see how long your filesystems last?

You could have asked why the lock was necessary, and I would have
described it. That would have been the civil approach. Maybe even
put forward a hypothesis why you think the lock isn't necessary, but
no, you decide that the best way to go about this is to remove the
lock and see whether the kernel breaks.

It may shock you to know that those of us who have been working on
the kernel for almost 30 years and have seen the evolution of the
kernel from uniprocessor to SMP, have had to debug race conditions
caused by a lack of locking know very well that you can have what
seems to be a functioning kernel despite missing locks - and such a
kernel can last quite a long time and only show up the race quite
rarely. This is exactly why "lets remove the lock and see if it
breaks" is a completely invalid approach. I'm sorry that you don't
seem to realise just how stupid a suggestion that was.

I can tell you now: removing the locks you proposed will not show an
immediate problem, but by removing those locks you will definitely
open up race conditions between driver binding events on the SFP
side and network usage on the netdev side which will only occur
rarely.

And just because they only happen rarely is not a justification to
remove locks, no matter how inconvenient those locks may be.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
