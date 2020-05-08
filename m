Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186721CB677
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHSAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHSAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:00:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0299AC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 11:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QExk3EZG5uPu5juFb4XZnttkMvCHgacCPYtEQ8qOgTs=; b=XiEJEPkMFQrHC1lUg+JHqjT7S
        4UNNvV1XMxuD54CiL21arZ4IGp3k3s8+HpFZ8rmLLwTCwLr96vcsb5zmp5evY/u+weGl33+NhPJJv
        6p1KIvNn+tS4v+bHELgpaRJ3sMwKlOc6z/poB/cqWJlyvGKRJ5k4pvO717e4u/lTpkruQfA2lMmEl
        jNV1mCkDAn2RuIRUffxeBTUbklXufOhS2wvFqN+oTd9w0UbTxlscoLo8ScA4U/OQ4hciNIohQ5FY7
        UCk4I0J2QRgw/oqjl+Ftdm81117GbOlFctpUCJML2WFj49VxAHXnVxqdI9rzhtMZd8PUg/fBF56Ah
        DQ/LFlcFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57854)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jX7IP-0001fY-93; Fri, 08 May 2020 19:00:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jX7IO-000216-9e; Fri, 08 May 2020 19:00:24 +0100
Date:   Fri, 8 May 2020 19:00:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: add some quirks for FreeTel direct
 attach modules
Message-ID: <20200508180024.GX1551@shell.armlinux.org.uk>
References: <20200507132135.316-1-marek.behun@nic.cz>
 <20200508152844.GV1551@shell.armlinux.org.uk>
 <20200508182706.06394c88@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200508182706.06394c88@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 06:27:06PM +0200, Marek Behun wrote:
> On Fri, 8 May 2020 16:28:44 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Thu, May 07, 2020 at 03:21:35PM +0200, Marek Behún wrote:
> > > FreeTel P.C30.2 and P.C30.3 may fail to report anything useful from
> > > their EEPROM. They report correct nominal bitrate of 10300 MBd, but do
> > > not report sfp_ct_passive nor sfp_ct_active in their ERPROM.
> > > 
> > > These modules can also operate at 1000baseX and 2500baseX.
> > > 
> > > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> > > index 6900c68260e0..f021709bedcc 100644
> > > --- a/drivers/net/phy/sfp-bus.c
> > > +++ b/drivers/net/phy/sfp-bus.c
> > > @@ -44,6 +44,14 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
> > >  	phylink_set(modes, 2500baseX_Full);
> > >  }
> > >  
> > > +static void sfp_quirk_direct_attach_10g(const struct sfp_eeprom_id *id,
> > > +					unsigned long *modes)
> > > +{
> > > +	phylink_set(modes, 10000baseCR_Full);
> > > +	phylink_set(modes, 2500baseX_Full);
> > > +	phylink_set(modes, 1000baseX_Full);
> > > +}
> > > +
> > >  static const struct sfp_quirk sfp_quirks[] = {
> > >  	{
> > >  		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> > > @@ -63,6 +71,18 @@ static const struct sfp_quirk sfp_quirks[] = {
> > >  		.vendor = "HUAWEI",
> > >  		.part = "MA5671A",
> > >  		.modes = sfp_quirk_2500basex,
> > > +	}, {
> > > +		// FreeTel P.C30.2 is a SFP+ direct attach that can operate at
> > > +		// at 1000baseX, 2500baseX and 10000baseCR, but may report none
> > > +		// of these in their EEPROM
> > > +		.vendor = "FreeTel",
> > > +		.part = "P.C30.2",
> > > +		.modes = sfp_quirk_direct_attach_10g,
> > > +	}, {
> > > +		// same as previous
> > > +		.vendor = "FreeTel",
> > > +		.part = "P.C30.3",
> > > +		.modes = sfp_quirk_direct_attach_10g,  
> > 
> > Looking at the EEPROM capabilities, it seems that these modules give
> > either:
> > 
> > Transceiver codes     : 0x01 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
> > Transceiver type      : Infiniband: 1X Copper Passive
> > Transceiver type      : Passive Cable
> > Transceiver type      : FC: Twin Axial Pair (TW)
> > Encoding              : 0x06 (64B/66B)
> > BR, Nominal           : 10300MBd
> > Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
> > BR margin, max        : 0%
> > BR margin, min        : 0%
> > 
> > or:
> > 
> > Transceiver codes     : 0x00 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
> > Transceiver type      : Passive Cable
> > Transceiver type      : FC: Twin Axial Pair (TW)
> > Encoding              : 0x06 (64B/66B)
> > BR, Nominal           : 10300MBd
> > Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
> > BR margin, max        : 0%
> > BR margin, min        : 0%
> > 
> > These give ethtool capability mask of 000,00000600,0000e040, which
> > is:
> > 
> > 	2500baseX (bit 15)
> > 	1000baseX (bit 41)
> > 	10000baseCR (bit 42)
> > 
> > 10000baseCR, 2500baseX and 1000baseX comes from:
> > 
> >         if ((id->base.sfp_ct_passive || id->base.sfp_ct_active) && br_nom) {
> >                 /* This may look odd, but some manufacturers use 12000MBd */
> >                 if (br_min <= 12000 && br_max >= 10300)
> >                         phylink_set(modes, 10000baseCR_Full);
> >                 if (br_min <= 3200 && br_max >= 3100)
> >                         phylink_set(modes, 2500baseX_Full);
> >                 if (br_min <= 1300 && br_max >= 1200)
> >                         phylink_set(modes, 1000baseX_Full);
> > 
> > since id->base.sfp_ct_passive is true, and br_nom = br_max = 10300 and
> > br_min = 0.
> > 
> > 10000baseCR will also come from:
> > 
> >         if (id->base.sfp_ct_passive) {
> >                 if (id->base.passive.sff8431_app_e)
> >                         phylink_set(modes, 10000baseCR_Full);
> >         }
> > 
> > You claimed in your patch description that sfp_ct_passive is not set,
> > but the EEPROM dumps contain:
> > 
> > 	Transceiver type      : Passive Cable
> > 
> > which is correctly parsed by the kernel.
> > 
> > So, I'm rather confused, and I don't see why this patch is needed.
> > 
> 
> Russell,
> 
> something is wrong here, and it is my bad. I hope I didn't mix
> the EEPROM images from when I was playing with the contents, but it
> seems possible now :( I probably sent you modified images and lost the
> original ones.

Ah.

> The thing I know for sure is that it did not work when I got the
> cables and also that they had different contents inside - ie at least
> one side of one cable did not report ct_passive nor ct_active. And I
> think that they reported different things on each side.

One of your files did have a difference in the capabilities - it was
missing the Infiniband capability mentioned above.

> I will try to get another such cable and return to this.

Thanks.

One thing we could do is to augment the "guessing" towards the end of
sfp_parse_support() so that if we encounter a module indicating
support for 10300MBd and 64B/66B, we could set one of the 10G properties
so that at least we get some functionality from modules that report
no capabilities.  See:

        /* If we haven't discovered any modes that this module supports, try
         * the encoding and bitrate to determine supported modes. Some BiDi
         * modules (eg, 1310nm/1550nm) are not 1000BASE-BX compliant due to
         * the differing wavelengths, so do not set any transceiver bits.
         */
        if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
                /* If the encoding and bit rate allows 1000baseX */
                if (id->base.encoding == SFF8024_ENCODING_8B10B && br_nom &&
                    br_min <= 1300 && br_max >= 1200)
                        phylink_set(modes, 1000baseX_Full);
        }

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
