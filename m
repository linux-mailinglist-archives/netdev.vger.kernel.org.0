Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC4B17365F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgB1LsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:48:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54054 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1LsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c9KhOrq2gOTbKBSsUSPBlkMn2esfMi/WqxI3fnMTFQg=; b=dy1vhT7N6x24wF1cdMc4yum7a
        KBsbReBNpWhyqcP0/rRJ9UdD8EiqChUIycgPqz5T/fn0nB1cU90Qb4bth45mMhCAXctL/C+vWTw9Y
        rAvoZHxXT+mvZjkI0K5MNetrYDbGk5IiY5jgzh507kStUsf7OvZ2fmzNEQzRenm/X3+zv/JBGQ2W2
        7nFOH8xQozhgS98rljsazB4RWAQonUg3AK/qS6hdmtV04psfu0TzMtQJpvO6nUWFgblp8IrnvEJaq
        R6nAZZ9QQFmmbqN0p/jsqPuDTnEuhN2PMC0HyszetcRuFTJhmWzhpEXqfl/KremAV5sxieUuNOvUs
        hbYUoIlJQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:46392)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7e7Y-0003aI-Rb; Fri, 28 Feb 2020 11:47:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7e7V-0001xQ-Ew; Fri, 28 Feb 2020 11:47:53 +0000
Date:   Fri, 28 Feb 2020 11:47:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v8 1/1] net: ag71xx: port to phylink
Message-ID: <20200228114753.GN18808@shell.armlinux.org.uk>
References: <20200226054624.14199-1-o.rempel@pengutronix.de>
 <20200226092138.GV25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226092138.GV25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:21:38AM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Feb 26, 2020 at 06:46:24AM +0100, Oleksij Rempel wrote:
> > The port to phylink was done as close as possible to initial
> > functionality.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> > changes v8:
> > - set the autoneg bit
> > - provide implementations for the mac_pcs_get_state and mac_an_restart
> >   methods
> > - do phylink_disconnect_phy() on _stop()
> > - rename ag71xx_phy_setup() to ag71xx_phylink_setup() 
> 
> There will be one more change required; I'm changing the prototype for
> the mac_link_up() function, and I suggest as you don't support in-band
> AN that most of the setup for speed and duplex gets moved out of your
> mac_config() implementation to mac_link_up().
> 
> The patches have been available on netdev for just over a week now.

The patches are now in net-next.  Please respin your patch against these
changes, which basically means the code which programs the speed and
duplex in ag71xx_mac_config() needs to be moved to ag71xx_mac_link_up().

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
