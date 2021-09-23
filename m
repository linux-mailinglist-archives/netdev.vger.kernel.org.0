Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BD34159F9
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 10:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbhIWIVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 04:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbhIWIVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 04:21:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC214C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 01:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ao4ccLwyooufgrmk2CojZeNgKOy5V8GBM4YWvOAJKUM=; b=KCbXGLZVRx/0U40LJxg8X6WUaw
        Ng53BaekUXu5RMEz6j4DHrm9QPCKeJOyAfIjvtCM7spa8m/k8uEpYN+QiP+3blwaE2aPQnG5Fn3zy
        JwUcziyDj/r2lNDkfLV7Xe9rVZvxHU1deWmPTIjl7kXguxqD8jz+03iWAs2+FpqTHEQotY4SWPLAt
        ZfOxHRQq33QjFs/QsEGB7ZiqRMAV7AGAe6dJVxgCSpAH9HmUBbDQdgSO3BFqlqtzcdrLgSEk231Zf
        Wg3MOYyNXPHObeCL+LIENwpE0D68c0W0dsnwx04v6dhg1/NxJxprSBEqysBt5ug7D11xFVirnOho7
        a+bW3J1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54750)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mTJwx-0004lA-IZ; Thu, 23 Sep 2021 09:19:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mTJwv-000553-6G; Thu, 23 Sep 2021 09:19:21 +0100
Date:   Thu, 23 Sep 2021 09:19:21 +0100
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
Message-ID: <YUw4iTLblfpOrdwm@shell.armlinux.org.uk>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
 <20210922213116.7wlvnjfeqjltiecs@skbuf>
 <20210922214827.wczsgk3yw3vjsv5w@skbuf>
 <YUu2OlXElk5GR/3N@shell.armlinux.org.uk>
 <20210922235033.hoz4rbx2eid6snyc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922235033.hoz4rbx2eid6snyc@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:50:34PM +0000, Vladimir Oltean wrote:
> On Thu, Sep 23, 2021 at 12:03:22AM +0100, Russell King (Oracle) wrote:
> > On Wed, Sep 22, 2021 at 09:48:28PM +0000, Vladimir Oltean wrote:
> > > On Thu, Sep 23, 2021 at 12:31:16AM +0300, Vladimir Oltean wrote:
> > > > On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) wrote:
> > > > > On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> > > > > > +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
> > > > > > +					      struct phy_device *phy,
> > > > > > +					      unsigned int mode)
> > > > > > +{
> > > > > > +	int ret;
> > > > > > +
> > > > > > +	ret = phy_validate_inband_aneg(phy, pl->link_interface);
> > > > > > +	if (ret == PHY_INBAND_ANEG_UNKNOWN) {
> > > > > > +		phylink_dbg(pl,
> > > > > > +			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
> > > > > > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > > > > > +
> > > > > > +		return mode;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
> > > > > > +		phylink_err(pl,
> > > > > > +			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
> > > > >
> > > > > If we add support to the BCM84881 driver to work with
> > > > > phy_validate_inband_aneg(), then this will always return
> > > > > PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> > > > > this will always produce this "error". It is not an error in the
> > > > > SFP case, but it is if firmware is misconfigured.
> > > > >
> > > > > So, this needs better handling - we should not be issuing an error-
> > > > > level kernel message for something that is "normal".
> > > >
> > > > Is this better?
> > > >
> > > > 		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
> > > > 			       "Requested in-band autoneg but driver does not support this, disabling it.\n");
> > >
> > > Ah, not sure whether that was a trick question or not, but
> > > phylink_fixup_inband_aneg function does not get called for the SFP code
> > > path, I even noted this in the commit message but forgot:
> >
> > No it wasn't a trick question. I thought you were calling
> > phylink_fixup_inband_aneg() from phylink_sfp_config(), but I see now
> > that you don't. That's what happens when you try and rush to review.
> 
> How did I "rush to review" exactly? I waited for 24 days since the v2
> for even a single review comment, with even a ping in between, before
> resending the series largely unaltered, just with an extra patch appended.

FFS. Are you intentionally trying to misinterpret everything I say?
Who here is doing a review? You or me?

"That's what happens when you try and rush to review." is a form of
speech - clearly the "you" is not aimed at you Vladimir, but me.
Let's put this a different way.

I am blaming myself for rushing to review this last night.

Is that more clear for you?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
