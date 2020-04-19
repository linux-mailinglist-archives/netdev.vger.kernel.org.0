Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332F51AFC9C
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgDSRNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726668AbgDSRNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:13:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC5BC061A0C;
        Sun, 19 Apr 2020 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zLl/O8f9jYA4cx5fo7LmDJmUNDdHX/VFattYUnbZWo8=; b=TTrTHJ5Rl6+8WqZ4OVlavXUHL
        b/MV6/U2DqN0ZXFUb2Yoi2cyAb5MSV26h765gK+qxknuS9jU3aB7/puQhHat0yjv+wISB27caT4Za
        uw0Lnm/WxRbGq3brZJb56U5bAQYtc5kYIXp2uhoyn99VfG6iP7DdPKBs6B2r9gyHqs18vlL3wXqN9
        NxGHEHHpE9mvWtMGrKQEI2QdpQpS5Oty6IQ7+gZol1OElt//d4GhtdmGPYoGTPTLwmql+YZVlJpsj
        j6ucxTdswTesUGNYNY395InePIr+nJScTsEhezWYe8XSlEgxQCeqlCdNWXPVsZsywAndOB9BPEtNk
        niXy2U1Ag==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48106)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jQDUo-0006lc-67; Sun, 19 Apr 2020 18:12:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jQDUd-000515-O4; Sun, 19 Apr 2020 18:12:31 +0100
Date:   Sun, 19 Apr 2020 18:12:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200419171231.GY25745@shell.armlinux.org.uk>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
 <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419162928.GL836632@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 06:29:28PM +0200, Andrew Lunn wrote:
> On Sun, Apr 19, 2020 at 12:29:23PM +0200, Michael Walle wrote:
> > Am 2020-04-17 23:28, schrieb Andrew Lunn:
> > > On Fri, Apr 17, 2020 at 11:08:56PM +0200, Michael Walle wrote:
> > > > Am 2020-04-17 22:13, schrieb Andrew Lunn:
> > > > > > Correct, and this function was actually stolen from there ;) This was
> > > > > > actually stolen from the mscc PHY ;)
> > > > >
> > > > > Which in itself indicates it is time to make it a helper :-)
> > > > 
> > > > Sure, do you have any suggestions?
> > > 
> > > mdiobus_get_phy() does the bit i was complaining about, the mdiobus
> > > internal knowledge.
> > 
> > But that doesn't address your other comment.
> 
> Yes, you are right. But i don't think you can easily generalize the
> rest. It needs knowledge of the driver private structure to reference
> pkg_init. You would have to move that into phy_device.
> 
> > 
> > > There is also the question of locking. What happens if the PHY devices
> > > is unbound while you have an instance of its phydev?
> > 
> > Is there any lock one could take to avoid that?
> 
> phy_attach_direct() does a get_device(). That at least means the
> struct device will not go away. I don't know the code well enough to
> know if that will also stop the phy_device structure from being freed.

Well, struct device is embedded in struct mdio_device, which in turn
is embedded in struct phy_device. So, if struct device can't go away
because its refcount is held, the same is true of the structs
embedding it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
