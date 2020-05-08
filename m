Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C016A1CB26E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEHPCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgEHPCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:02:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAFBC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HzMR/z5LYpKdNLnBXcKtNxNMMDSg2ncbGSGZdgdz+tA=; b=cRWIvtcy/NoVOVLORwufYwNqW
        GolxjDKMqbyP7U3iTQWtMfiVRl07Lwa6Yiy1YHYvZKZ9wYyrmsSwvcLLVQSwuv/IFzWxR9DhbZhvQ
        e208b4mnvNFhXcdN6meb/tsjEEBkYuf/90OwlGiZuo9rEW/qc7iXJIWRrR7Epz3pp90RhKMRhZQdX
        OqO501Ec5k8m3TPUj/cptCCJECa9LVHI+oZUTGMs+jZTanLpt30FDh7xRxQcWnRdY7nZA5Sxp2R6B
        WCREeRrkfEdnTagbeO/swmOJLcBqZtUyH9LO1kgmsOOT1pb6FYFKlIavNqT9RA0aVsWREVHs+QG3Z
        FDMx7aZZA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37626)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jX4WC-0001FY-Vu; Fri, 08 May 2020 16:02:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jX4WB-0001rp-FJ; Fri, 08 May 2020 16:02:27 +0100
Date:   Fri, 8 May 2020 16:02:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: sfp: add some quirks for FreeTel direct
 attach modules
Message-ID: <20200508150227.GU1551@shell.armlinux.org.uk>
References: <20200507132135.316-1-marek.behun@nic.cz>
 <CAOJe8K03_BFvfMHOUibi6OZLt28Z8Cn1katyhvJHP5b1rFZbUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJe8K03_BFvfMHOUibi6OZLt28Z8Cn1katyhvJHP5b1rFZbUw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:30:06PM +0300, Denis Kirjanov wrote:
> On Thursday, May 7, 2020, Marek Behún <marek.behun@nic.cz> wrote:
> 
> > FreeTel P.C30.2 and P.C30.3 may fail to report anything useful from
> > their EEPROM. They report correct nominal bitrate of 10300 MBd, but do
> > not report sfp_ct_passive nor sfp_ct_active in their ERPROM.
> >
> > These modules can also operate at 1000baseX and 2500baseX.
> >
> > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> > index 6900c68260e0..f021709bedcc 100644
> > --- a/drivers/net/phy/sfp-bus.c
> > +++ b/drivers/net/phy/sfp-bus.c
> > @@ -44,6 +44,14 @@ static void sfp_quirk_2500basex(const struct
> > sfp_eeprom_id *id,
> >         phylink_set(modes, 2500baseX_Full);
> >  }
> >
> > +static void sfp_quirk_direct_attach_10g(const struct sfp_eeprom_id *id,
> > +                                       unsigned long *modes)
> > +{
> > +       phylink_set(modes, 10000baseCR_Full);
> > +       phylink_set(modes, 2500baseX_Full);
> > +       phylink_set(modes, 1000baseX_Full);
> > +}
> > +
> >  static const struct sfp_quirk sfp_quirks[] = {
> >         {
> >                 // Alcatel Lucent G-010S-P can operate at 2500base-X, but
> > @@ -63,6 +71,18 @@ static const struct sfp_quirk sfp_quirks[] = {
> >                 .vendor = "HUAWEI",
> >                 .part = "MA5671A",
> >                 .modes = sfp_quirk_2500basex,
> > +       }, {
> > +               // FreeTel P.C30.2 is a SFP+ direct attach that can
> > operate at
> > +               // at 1000baseX, 2500baseX and 10000baseCR, but may report
> > none
> > +               // of these in their EEPROM
> 
> 
>  Hi Marek,
> 
> The comment style above is not what Linux kernel uses

The comment style is per file - keeping consistency within a file is
far more important than rigid conformance to some coding style. That
is, unless someone is prepared to convert said file.  The commenting
style for these entries is to use "//" style.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
