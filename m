Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99AF75D6
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKKOB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:01:28 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33852 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKOB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MKE2hB+3RWdhAJQ0B3LZjNwxwmp7zaNGKossbXgQPYI=; b=zrchXQyLmnMsxQQwsz6RxXw5M
        kg+QgEaadaZBGQneebN/bbe8g9glclDWtJWM90Z+7njWz/mpJTsD0djItlEd8a2K+/jUFXDzKpXu7
        5VlKT3f5Us8MKwmbSi6r9uSCmFrjJA3oRk0jrOhwmnd0uHWpo6uH2cEWsRZR87AalB+K9FTZ2bAqU
        r3jyFiQlCPHo5ZUbR+SHZM1T3bdq3zGo9KwFWx1/pjjham7iuRJtobLBz4VmkS373MBYNJyakEboc
        d75BuqXWb5d6i536gHd2t/gyotsjNX0zPwavYqnelS4KvDJvizD/YIwOg3P2GdFaunViy/ZTElUzw
        TvhQ/g89Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54806)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iUAFq-00062i-3G; Mon, 11 Nov 2019 14:01:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iUAFn-0000XW-3F; Mon, 11 Nov 2019 14:01:15 +0000
Date:   Mon, 11 Nov 2019 14:01:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191111140114.GH25745@shell.armlinux.org.uk>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch>
 <20191110164007.GC25745@shell.armlinux.org.uk>
 <20191110170040.GG25889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110170040.GG25889@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 06:00:40PM +0100, Andrew Lunn wrote:
> On Sun, Nov 10, 2019 at 04:40:07PM +0000, Russell King - ARM Linux admin wrote:
> > On Sun, Nov 10, 2019 at 05:13:07PM +0100, Andrew Lunn wrote:
> > > On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> > > > Add core phylib help for supporting SFP sockets on PHYs.  This provides
> > > > a mechanism to inform the SFP layer about PHY up/down events, and also
> > > > unregister the SFP bus when the PHY is going away.
> > > 
> > > Hi Russell
> > > 
> > > What does the device tree binding look like? I think you have SFP
> > > proprieties in the PHYs node?
> > 
> > Correct, just the same as network devices.  Hmm, however, neither are
> > documented... oh dear, it looks like I need to figure out how this
> > yaml stuff works. :(
> 
> Yes, that would be good. I also assume you have at least one DT patch
> for one of the Marvell boards? Seeing that would also help.

So, how does one make sure that the .yaml files are correct?

The obvious thing is to use the "dtbs_check" target, described by
Documentation/devicetree/writing-schema.md, but that's far from
trivial.

First it complained about lack of libyaml development, which is easy
to solve.  Having given it that, "dtbs_check" now complains:

/bin/sh: 1: dt-doc-validate: not found
/bin/sh: 1: dt-mk-schema: not foundmake[2]: ***
[...Documentation/devicetree/bindings/Makefile:12:
Documentation/devicetree/bindings/arm/stm32/stm32.example.dts] Error 127

(spot the lack of newline character - which is obviously an entirely
different problem...)

# apt search dt-doc-validate
Sorting... Done
Full Text Search... Done
# apt search dt-mk-schema
Sorting... Done
Full Text Search... Done

Searching google, it appears it needs another git repository
(https://github.com/robherring/dt-schema/) from Rob Herring to use
this stuff, which is totally undocumented in the kernel tree.

Rob, can we have some _decent_ documentation on how to use this stuff
please, particularly something that describes what the external
dependencies are and where to get the necessary code from - it's
rather unfair to make documentation of DT properties a requirement
for integration into the kernel, convert the documentation to .yaml
format, and not tell people how they can sensibly validate it.  Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
