Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F2D224358
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGQSvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQSvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:51:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2ADC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pQWO8nkBE2sSav8vtk55BNa5naTLwoATorhiMpKR31I=; b=w/2wJ1zKdwnCyyiVEo9gzGX0m
        bdn6LUVdkNf+AX+OQ4o4yZuAqcPE4G+PegJguw4qAsTGefclqotBYzoUy4HyTpmGQIAs8CpOX3R6w
        RA2rx7OWh05Y2xUMmr/BqDJg7LqCipwCXq0bJe0eteBnT0utd/DR1duqbC0Cpmw/AlAcRTkv5iIfR
        ElhinB/GILQgUdKQ6Urvh98rkvnj521MN+egb/EK9SrON7SGlsAtG1cQV/9SxG7uku8MwqoT4EYOY
        mnlKrgEUQTwEmqD+y4OESgbmK+53644IzSVQzfqPN8HhWCOidyO8zB+7RyPWmULKfHuepcDLbbTLM
        itSPqfQ1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40746)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwVS6-0000zm-4Y; Fri, 17 Jul 2020 19:51:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwVS3-000280-JF; Fri, 17 Jul 2020 19:51:19 +0100
Date:   Fri, 17 Jul 2020 19:51:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200717185119.GL1551@shell.armlinux.org.uk>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
 <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:50:07PM +0000, Martin Rowe wrote:
> On Fri, 17 Jul 2020 at 09:22, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > The key file is /sys/kernel/debug/mv88e6xxx.0/regs - please send the
> > contents of that file.
> 
> $ cat regs.broken
>     GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
>  0:  c800       0    ffff  9e07 9e4f 100f 100f 9e4f 170b
>  1:     0    803e    ffff     3    3    3    3    3 201f
                                                      ^^^^
This is where the problem is.

>  1:     0    803e    ffff     3    3    3    3    3 203f
                                                      ^^^^

In the broken case, the link is forced down, in the working case, the
link is forced up.

What seems to be happening is:

dsa_port_link_register_of() gets called, and we do this:

                phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
                if (of_phy_is_fixed_link(dp->dn) || phy_np) {
                        if (ds->ops->phylink_mac_link_down)
                                ds->ops->phylink_mac_link_down(ds, port,
                                        MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
                        return dsa_port_phylink_register(dp);

which forces the link down, and for some reason the link never comes
back up.

One of the issues here is of_phy_is_fixed_link() - it is dangerous.
The function name leads you astray - it suggests that if it returns
true, then you have a fixed link, but it also returns true of you
have managed!="auto" in DT, so it's actually fixed-or-inband-link.

Andrew, any thoughts?

I think it's looking more and more like we need my phylink hack to
grab the "defaults" for the port on phylink_start() to allow DSA to
work sanely with phylink, so that phylink can have the complete
information about the CPU port at all times.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
