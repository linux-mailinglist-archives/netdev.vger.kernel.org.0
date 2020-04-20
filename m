Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D61B12D8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDTRUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgDTRUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:20:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC37C061A0C;
        Mon, 20 Apr 2020 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d8hn8TYhXkanozCI896xHfztLh3G1m8lpd0qQJenmuE=; b=Ie5TFC4xXLvpH8VIdZhJgD/vQ
        U0UnL3buhmistVbJaceQe2O08t0R8ajzlMqcANzrvhpG7EVkigE99IQIPz3V21WX7wXNlCAWbbMg+
        KacUXQy44xapf7PVhh6B1RCbSqXheTXfugi9pzz/TTW33QFoxAqUov3nKP1dUV9CRISq5YoV5ghrx
        rD2eDKRilSdZiaks8OJHTv47vE1YMWE2b7KqwcsRi15gvUfmm6bWCBvE1GZ7xEdsB4M8v+TpHf9wc
        k6fPgbq22LikuV14yTqjXD1DOX/TvSXJkhxDqsC3tN5kXgezZ2+SzwXbtb13DjMhMBjzZwDiPn8xT
        Dle/kOZKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52812)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jQa5i-0004i2-Nw; Mon, 20 Apr 2020 18:20:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jQa5d-00060E-8D; Mon, 20 Apr 2020 18:20:13 +0100
Date:   Mon, 20 Apr 2020 18:20:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200420172013.GZ25745@shell.armlinux.org.uk>
References: <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
 <20200419170547.GO836632@lunn.ch>
 <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
 <20200419215549.GR836632@lunn.ch>
 <75428c5faab7fc656051ab227663e6e6@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75428c5faab7fc656051ab227663e6e6@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 05:10:19PM +0200, Michael Walle wrote:
> Hi Andrew,
> 
> Am 2020-04-19 23:55, schrieb Andrew Lunn:
> > > But what does that have to do with the shared structure? I don't think
> > > you have to "bundle" the shared structure with the "access the global
> > > registers" method.
> > 
> > We don't need to. But it would be a good way to clean up code which
> > locks the mdio bus, does a register access on some other device, and
> > then unlocks the bus.
> 
> I'd like do an RFC for that. But how should I proceed with the original
> patch series? Should I send an updated version; you didn't reply to the
> LED stuff. That is the last remark for now.

The LED stuff is something that there isn't a solution for at the
moment.  There's been talk about coming up with some generic way
to describe the PHY LED configuration in DT, but given that almost
every PHY has quite different ways to configure LEDs, I fear such
a task is virtually impossible.

Very few PHYs under Linux have their LEDs operating "correctly" or
in a meaningful or sensible way because of this, and it's been this
way for years.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
