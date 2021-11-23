Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748D445AB2A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhKWSSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 13:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbhKWSS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 13:18:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC5BC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 10:15:20 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o20so51345319eds.10
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 10:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G4bF4BlHu19yj+PnhrbJg/JdwAK3eJi9pLosmSh+cbE=;
        b=HRhBuquCwUvbC0oxRhV+DgtxNhsbO4pAqBz4OfG5S0woEJFuSzAh6PcXEmtbjdPIDB
         VAhquJO+2SpjUIWj9/QHMvY3UQhfLHht+c61mxgfOVRhOSZQp0UNf7H+ASV7mJQz03Ev
         /LavqY+H3PZaSsJ9345pbqtNLpGVL8DykQZ2U7RFrVSbEff5c/MnRWUcCaZCKiXZKwUx
         GswCs5rH3Oj8d59W+h3oAUG3F6cn0goEEcGVP6YsN2hYm/6Rfvoxlu0K2JSIVLy9JW3K
         rH3rSq7PbST9x0zRRvmvmmln5tzThtvjOZHiB0qHyzu7JXhGBWrne4zed55jrM94Sx1m
         r6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G4bF4BlHu19yj+PnhrbJg/JdwAK3eJi9pLosmSh+cbE=;
        b=eikRahKbge+uaxJo+baHgSJOjH4Lw4zb15tS5tw3d97AoFEqxfTWEFX5TerAQsZ/Yh
         ZqATMDPhjRyTIFIwxDhvIh9LbTZJUxImtyNVGi5GGqrgAW6RvwE+biGlaIr+8FHyuGUb
         seJExuct87e2Gh9qpHSlBE9McUHg2M3WYVCTs9VNUGlPC+JELBLQmNgO4Wa5zRvAUfwx
         YFiH0D40Ct/WJOtQn2BnfOL/qnc8MLZw2cbLi/IC+Qbr94aH85Gyvd8xRTVYg9sw2TXP
         vc2g8ZWrCzQ/vQrGTz7rHJFresjxejxheGly4P6JL+3PW3wWE1JyPqOFbpa2tl1YjSAr
         RzJQ==
X-Gm-Message-State: AOAM531Obp2GEUZZztzP1+CYatkb2DWH6Mmti8LOEi1IDYMR78m2sdto
        R6LBSSFHdwlD5JjnRcP1PQ4=
X-Google-Smtp-Source: ABdhPJw1Dn5uOcx7PXU3F32tP7tB8DwfdSVaQTlX53sPUB+WXWewl+EXKMLHK195+NVC/Ubah60M0w==
X-Received: by 2002:a05:6402:2043:: with SMTP id bc3mr12513407edb.231.1637691317815;
        Tue, 23 Nov 2021 10:15:17 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id go17sm5818614ejc.76.2021.11.23.10.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 10:15:17 -0800 (PST)
Date:   Tue, 23 Nov 2021 20:15:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Chris Snook <chris.snook@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
Message-ID: <20211123181515.qqo7e4xbuu2ntwgt@skbuf>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
 <20211123120825.jvuh7444wdxzugbo@skbuf>
 <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
 <90262b1c-fee2-f906-69df-1171ff241077@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90262b1c-fee2-f906-69df-1171ff241077@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:30:33PM -0500, Sean Anderson wrote:
> On 11/23/21 11:08 AM, Russell King (Oracle) wrote:
> > On Tue, Nov 23, 2021 at 02:08:25PM +0200, Vladimir Oltean wrote:
> > > On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
> > > > Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
> > > > the PCS from phylink. This is only supported on non-legacy drivers
> > > > where doing so will have no effect on the mac_config() calling
> > > > behaviour.
> > > >
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
> > > >  1 file changed, 15 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > index a935655c39c0..9f0f0e0aad55 100644
> > > > --- a/drivers/net/phy/phylink.c
> > > > +++ b/drivers/net/phy/phylink.c
> > > > @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
> > > >   * in mac_prepare() or mac_config() methods if it is desired to dynamically
> > > >   * change the PCS.
> > > >   *
> > > > - * Please note that there are behavioural changes with the mac_config()
> > > > - * callback if a PCS is present (denoting a newer setup) so removing a PCS
> > > > - * is not supported, and if a PCS is going to be used, it must be registered
> > > > - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
> > > > + * Please note that for legacy phylink users, there are behavioural changes
> > > > + * with the mac_config() callback if a PCS is present (denoting a newer setup)
> > > > + * so removing a PCS is not supported. If a PCS is going to be used, it must
> > > > + * be registered by calling phylink_set_pcs() at the latest in the first
> > > > + * mac_config() call.
> > > > + *
> > > > + * For modern drivers, this may be called with a NULL pcs argument to
> > > > + * disconnect the PCS from phylink.
> > > >   */
> > > >  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
> > > >  {
> > > > +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
> > > > +		phylink_warn(pl,
> > > > +			     "Removing PCS is not supported in a legacy driver");
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	pl->pcs = pcs;
> > > > -	pl->pcs_ops = pcs->ops;
> > > > +	pl->pcs_ops = pcs ? pcs->ops : NULL;
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(phylink_set_pcs);
> > > >
> > > > --
> > > > 2.30.2
> > > >
> > > 
> > > I've read the discussion at
> > > https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
> > > and I still am not sure that I understand what is the use case behind
> > > removing a PCS?
> > 
> > Passing that to Sean to answer in detail...
> 
> My original feedback was regarding selecting the correct PCS to use. In
> response to the question "What PCS do you want to use for this phy
> interface mode?" a valid response is "I don't need a PCS," even if for a
> different mode a valid response might be "Please use X PCS."

Yes, but that is not a reason why you'd want to _remove_ one. Just don't
call phylink_set_pcs() in the first place, there you go, no PCS.

> Because this function is used in validate(), it is necessary to
> evaluate "what-if" scenarios, even if a scenario requiring a PCS and
> one requiring no PCS would never actually be configured.

Yes, but on the same port on the same board? The MAC-side PCS is an
integral part of serial Ethernet links, be it modeled as a discrete part
by hardware manufacturers or not. We are effectively talking about a
situation where a serial link would become parallel, or the other way
around. Have you seen such a thing?

> Typically the PCS is physically attached to the next layer in the link,
> even if the hardware could be configured not to use the PCS. So it does
> not usually make sense to configure a link to use modes both requiring a
> PCS and requiring no PCS. However, it is possible that such a system
> could exist. Most systems should use `phy-mode` to restrict the phy
> interfaces modes to whatever makes sense for the board. I think Marek's
> series (and specifically [1]) is an good step in this regard.
> 
> --Sean
> 
> [1] https://lore.kernel.org/netdev/20211123164027.15618-5-kabel@kernel.org/

Marek's patches are for reconfiguring the SERDES protocol on the same
lanes. But the lanes are still physically there, and you'd need a PCS to
talk to them no matter what you do, they won't magically turn into RGMII.
If you need to switch the MAC PCS you're configuring with another MAC
PCS (within the same hardware block more or less) due to the fact that
the SERDES protocol is changing, that doesn't count as removing the PCS,
does it? Or what are you thinking of when you say PCS? Phylink doesn't
support any other kind of PCS than a MAC-side PCS.
