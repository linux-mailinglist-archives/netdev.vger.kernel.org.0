Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13BF4153B4
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbhIVXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhIVXE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 19:04:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59051C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RwmYTKKm1LXpx790bCYOVC1KYiVIkGg8Us7EvsBQagg=; b=i26+S/MlJKiIc79kmJ3oF46hTD
        GpWZrs1jGamTPKrUzio3skpWYSZTliokTJyXbtjwcsoRSzC47ptXB4vEgKJUXeIbVMK+q6ssz9kzQ
        lsgQBp4qma9hTRbwQQcvR8OolCYYqeVU3JLVIz4BEyoCR5ziziGcNuGQi2eEm0c7isIM58RHHt0Dp
        hmgKlFSjLF/ssFYNbfxtmZSlFuuxvBzZxsnIziDL1j67PP8AVfduYOvpgFXAXXVv7zdvE9LyXQ4cY
        BR+WE4Ac8XuZTJV9DhycxzuSsu5V2ulzg+6KAEd40LgX+hpn0v/f5mE5LRW3VpkICAevIdbD4/J62
        YQawgA5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54744)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mTBGu-0004Qi-Sf; Thu, 23 Sep 2021 00:03:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mTBGs-0004eF-48; Thu, 23 Sep 2021 00:03:22 +0100
Date:   Thu, 23 Sep 2021 00:03:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Message-ID: <YUu2OlXElk5GR/3N@shell.armlinux.org.uk>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
 <20210922213116.7wlvnjfeqjltiecs@skbuf>
 <20210922214827.wczsgk3yw3vjsv5w@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922214827.wczsgk3yw3vjsv5w@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 09:48:28PM +0000, Vladimir Oltean wrote:
> On Thu, Sep 23, 2021 at 12:31:16AM +0300, Vladimir Oltean wrote:
> > On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) wrote:
> > > On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> > > > +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
> > > > +					      struct phy_device *phy,
> > > > +					      unsigned int mode)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	ret = phy_validate_inband_aneg(phy, pl->link_interface);
> > > > +	if (ret == PHY_INBAND_ANEG_UNKNOWN) {
> > > > +		phylink_dbg(pl,
> > > > +			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
> > > > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > > > +
> > > > +		return mode;
> > > > +	}
> > > > +
> > > > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
> > > > +		phylink_err(pl,
> > > > +			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
> > > 
> > > If we add support to the BCM84881 driver to work with
> > > phy_validate_inband_aneg(), then this will always return
> > > PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> > > this will always produce this "error". It is not an error in the
> > > SFP case, but it is if firmware is misconfigured.
> > > 
> > > So, this needs better handling - we should not be issuing an error-
> > > level kernel message for something that is "normal".
> > 
> > Is this better?
> > 
> > 		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
> > 			       "Requested in-band autoneg but driver does not support this, disabling it.\n");
> 
> Ah, not sure whether that was a trick question or not, but
> phylink_fixup_inband_aneg function does not get called for the SFP code
> path, I even noted this in the commit message but forgot:

No it wasn't a trick question. I thought you were calling
phylink_fixup_inband_aneg() from phylink_sfp_config(), but I see now
that you don't. That's what happens when you try and rush to review.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
