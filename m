Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25D01E087B
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbgEYIKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387668AbgEYIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:10:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4644C061A0E;
        Mon, 25 May 2020 01:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LC2ca7J4tElTk2I/heSRPcYgSgFbGqANS02K/NJWcDo=; b=obG00Qt7LQTfPOiPNqgMB7Lvr
        gq83/vZzbzlg5mouAAvLKFbLgc0VcWr27b14tkBDW9DCo4bZCAHWFREQrBaurrNqlTQq7Eo6kSDG2
        NQs0q2u44yun3ewZ19FPfJNxrVIc0OxXjx5pR1L1eV3/78zxVoy9qsajDsbDduochmjhxHlZnByKl
        fw2qx2CpTrP9lXthA+gOrdCBdQG4keOiE7wc7BowJ+N9744grNA3GU1mRoxRxXGV611dp2ZhRGEuS
        F4oibzA/z9cF7BSFDCDSPanameeYNT6MMxQ8TV8l1RQfFdu3oIA/4sL9SYjZairGTg5u/HOdYeYJy
        eRa2rQ9Aw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34252)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd8B8-0004fj-8m; Mon, 25 May 2020 09:09:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd8B2-0004C5-AC; Mon, 25 May 2020 09:09:40 +0100
Date:   Mon, 25 May 2020 09:09:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/11] net: phy: Simplify MMD device list termination
Message-ID: <20200525080940.GF1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-3-jeremy.linton@arm.com>
 <20200523183610.GY1551@shell.armlinux.org.uk>
 <e25080cd-420a-da87-e13c-fa7e2ffb93a6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e25080cd-420a-da87-e13c-fa7e2ffb93a6@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 09:48:55PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/23/20 1:36 PM, Russell King - ARM Linux admin wrote:
> > On Fri, May 22, 2020 at 04:30:50PM -0500, Jeremy Linton wrote:
> > > Since we are already checking for *devs == 0 after
> > > the loop terminates, we can add a mostly F's check
> > > as well. With that change we can simplify the return/break
> > > sequence inside the loop.
> > > 
> > > Add a valid_phy_id() macro for this, since we will be using it
> > > in a couple other places.
> > 
> > I'm not sure you have the name of this correct, and your usage layer
> > in your patch series is correct.
> 
> Or the name is poor..
> 
> > 
> > > 
> > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > ---
> > >   drivers/net/phy/phy_device.c | 15 +++++++--------
> > >   1 file changed, 7 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index 245899b58a7d..7746c07b97fe 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -695,6 +695,11 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
> > >   	return 0;
> > >   }
> > > +static bool valid_phy_id(int val)
> > > +{
> > > +	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
> > > +}
> > > +
> > >   /**
> > >    * get_phy_c45_ids - reads the specified addr for its 802.3-c45 IDs.
> > >    * @bus: the target MII bus
> > > @@ -732,18 +737,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   			phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
> > >   			if (phy_reg < 0)
> > >   				return -EIO;
> > > -			/* no device there, let's get out of here */
> > > -			if ((*devs & 0x1fffffff) == 0x1fffffff) {
> > > -				*phy_id = 0xffffffff;
> > > -				return 0;
> > > -			} else {
> > > -				break;
> > > -			}
> > > +			break;
> > >   		}
> > >   	}
> > >   	/* no reported devices */
> > > -	if (*devs == 0) {
> > > +	if (!valid_phy_id(*devs)) {
> > 
> > You are using this to validate the "devices in package" value, not the
> > PHY ID value.  So, IMHO this should be called "valid_devs_in_package()"
> > or similar.
> 
> Hmmm, its more "valid_phy_reg()" since it ends up being used to validate
> both the devs in package as well as phy id.

I don't think that is a valid use of the code you've put in
valid_phy_id().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
