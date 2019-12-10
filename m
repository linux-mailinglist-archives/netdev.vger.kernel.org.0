Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2552B118F64
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfLJR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:58:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55154 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfLJR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YRbL7BC8heikbI6TJIee2jtC9tdOv+/0wRkq6Dn4rdE=; b=On68Cn3yWemBzuD1kQukO8sw7
        CPGdBdr+C3v/mrjUVyigVQQ1WmqxUZmRzhlwTgWDx60DemUdNeKwGjdpgvsUR/0MZ9JxWQ6YLMeS5
        t0CgK0PVLkLtWj99LnsjIIY08IT3aMjmeZ2UcydDZFyWwbxDaORI5lVpgO9Ah6rdl8mTc/W7jArd6
        5dbVFeRobu692STMjC4HkFI3zk/eGjad91RbJIY8vFAnjKuHbY9DEX+BTIgesQuoJpunYazm+g53r
        B/CP5EHzDLarzAhFwgED1GIB4oIsuwtRn9itFM0ozNfbpZ+tVtlyWz6Mhi1LPJjDvuX6G9VHju6QQ
        aJHyZngKA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39514)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iejmU-0002zz-2F; Tue, 10 Dec 2019 17:58:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iejmQ-0004q3-0J; Tue, 10 Dec 2019 17:58:38 +0000
Date:   Tue, 10 Dec 2019 17:58:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 13/14] net: phy: add Broadcom BCM84881 PHY
 driver
Message-ID: <20191210175837.GY25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKov-0004vw-Dk@rmk-PC.armlinux.org.uk>
 <557220a9-bdf4-868a-d9cd-a382ae80d288@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <557220a9-bdf4-868a-d9cd-a382ae80d288@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:34:16AM -0800, Florian Fainelli wrote:
> On 12/9/19 7:19 AM, Russell King wrote:
> > Add a rudimentary Clause 45 driver for the BCM84881 PHY, found on
> > Methode DM7052 SFPs.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> > ---
> >  drivers/net/phy/Kconfig    |   6 +
> >  drivers/net/phy/Makefile   |   1 +
> >  drivers/net/phy/bcm84881.c | 269 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 276 insertions(+)
> >  create mode 100644 drivers/net/phy/bcm84881.c
> > 
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index fe602648b99f..41272106dea9 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -329,6 +329,12 @@ config BROADCOM_PHY
> >  	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
> >  	  BCM5481, BCM54810 and BCM5482 PHYs.
> >  
> > +config BCM84881_PHY
> > +	bool "Broadcom BCM84881 PHY"
> > +	depends on PHYLIB=y
> > +	---help---
> > +	  Support the Broadcom BCM84881 PHY.
> 
> Cannot we make this tristate, I believe we cannot until there are more
> fundamental issues (that you just reported) to be fixed, correct?

Indeed.  The problem I saw was that although the bcm84881 has the
PHY correctly described, for whatever reason, the module was not
loaded.

What I think is going in is that with modern udev userspace,
request_module() is not functional, and we do not publish the
module IDs for Clause 45 PHYs via uevent.  Consequently, there
exists no mechanism to load a Clause 45 PHY driver from the
filesystem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
