Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2233D3FF4EC
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346489AbhIBUaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346225AbhIBUaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:30:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FACC061575;
        Thu,  2 Sep 2021 13:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GriFeb2SgN20Aboo2d1SssjdRTOJJ4BZ6odFesu7LVk=; b=y8KTWTcb4Tlp7zpMUfgFRmERt
        gGrQAo0N060ne7kHuVjcl+Vccdr59XlCvCrucfTTUDi9QuIiuZ4yjpFOjnFTgAdE1bFn1uINRsXqz
        Fw4n/Pm0gP7HwkjYO7jTCa0y5QefPLDq9dW6zLjVDTzSwxg6ohmjD0NgbWSI/hKH/WB7VNbT1y4ng
        RtyN9ddpOarh+LhK5qDostm6OHDFkOqHT8KpCTu/jLhibJZmveqnwK+rCn07fUfTRLbRyOoP08mK2
        VR3Lpj5d3qmZ3GHCPc1KJ7TERRL5lTWay3a6w0n/D/fqfNQa19/gosawhWb/jntGDa8hHNoglL0sL
        Vuja4uW0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48110)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLtKd-0001zi-Gt; Thu, 02 Sep 2021 21:29:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLtKb-0008CB-GV; Thu, 02 Sep 2021 21:29:05 +0100
Date:   Thu, 2 Sep 2021 21:29:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902202905.GN22278@shell.armlinux.org.uk>
References: <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902202124.o5lcnukdzjkbft7l@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 11:21:24PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 09:03:01PM +0100, Russell King (Oracle) wrote:
> > # systemctl list-dependencies networking.service
> > networking.service
> >   ├─ifupdown-pre.service
> >   ├─system.slice
> >   └─network.target
> > # systemctl list-dependencies ifupdown-pre.service
> > ifupdown-pre.service
> >   ├─system.slice
> >   └─systemd-udevd.service
> > 
> > Looking in the service files for a better idea:
> > 
> > networking.service:
> > Requires=ifupdown-pre.service
> > Wants=network.target
> > After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
> > Before=network.target shutdown.target network-online.target
> > 
> > ifupdown-pre.service:
> > Wants=systemd-udevd.service
> > After=systemd-udev-trigger.service
> > Before=network.target
> > 
> > So, the dependency you mention is already present. As is a dependency
> > on udev. The problem is udev does all the automatic module loading
> > asynchronously and in a multithreaded way.
> > 
> > I don't think there's a way to make systemd wait for all module loads
> > to complete.
> 
> So ifupdown-pre.service has a call to "udevadm settle". This "watches
> the udev event queue, and exits if all current events are handled",
> according to the man page. But which current events? ifupdown-pre.service
> does not have the dependency on systemd-modules-load.service, just
> networking.service does. So maybe ifupdown-pre.service does not wait for
> DSA to finish initializing, then it tells networking.service that all is ok.

ifupdown-pre.service does have a call to udevadm settle, and that
does get called from what I can tell.

systemd-modules-load.service is an entire red herring. The only
module listed in the various modules-load.d directories is "tun"
for openvpn (which isn't currently being used.)

As I've already told you (and you seem to have ignored), DSA gets
loaded by udev, not by systemd-modules-load.service.
systemd-modules-load.service is irrelevant to my situation.

I think there's a problem with "and exits if all current events are
handled" - does that mean it's fired off a modprobe process which
is in progress, or does that mean that the modprobe process has
completed.

Given that we can see that ifup is being run while the DSA module is
still in the middle of probing, the latter interpretation can not be
true - unless systemd is ignoring the dependencies. Or just in
general, systemd being systemd (I have very little faith in systemd
behaving as it should.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
