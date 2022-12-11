Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D96649643
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 21:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiLKUe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 15:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLKUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 15:34:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70B46321;
        Sun, 11 Dec 2022 12:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iuuvXx42fvHKO3uTvovo4/BdyujnUbI3TiuEn6vFJ0w=; b=WDLovEgqgjXgVvpy+FT4/N0hzW
        yQUJcLKR4hS8bddkqbfSRdcG0taRuKc/YKobQccurNLi0nc4ZlfwKMOwq9GQdf9NDPqRa/knouO09
        owmm3Yg2QrYXC5EcgLp0HixpoYDFS4zxUpDQqf0wXxNleWl+25kFMf3ob1hxUfOzxP3pTcbJdBWIM
        taqvMvjqBp9pyE0crKgYfKuWIbEv3uSF1kZGqxOsE6BUah5J89bDShOn6vL9SI6VYB4v70EwTEMzj
        /opIpxrd+KtsOjNIT+vZ2PDAj4tj0bFLLJG4I1GcHnXhySUdry5TA4+wHoB3wiYMAtc/BNfUykcG9
        0vpNDGTw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35666)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p4T1d-0004uO-Dc; Sun, 11 Dec 2022 20:34:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p4T1a-0004qL-VE; Sun, 11 Dec 2022 20:34:14 +0000
Date:   Sun, 11 Dec 2022 20:34:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v6 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
 <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
 <Y5Ypc5fDP3Cbi+RZ@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5Ypc5fDP3Cbi+RZ@gvm01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 08:03:15PM +0100, Piergiorgio Beruto wrote:
> On Sun, Dec 11, 2022 at 12:23:53PM +0000, Russell King (Oracle) wrote:
> > On Sat, Dec 10, 2022 at 11:46:39PM +0100, Piergiorgio Beruto wrote:
> > > This patch adds the required connection between netlink ethtool and
> > > phylib to resolve PLCA get/set config and get status messages.
> > > 
> > > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > > ---
> > >  drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
> > >  drivers/net/phy/phy_device.c |   3 +
> > >  include/linux/phy.h          |   7 ++
> > >  3 files changed, 185 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > > index e5b6cb1a77f9..40d90ed2f0fb 100644
> > > --- a/drivers/net/phy/phy.c
> > > +++ b/drivers/net/phy/phy.c
> > > @@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> > >  }
> > >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> > >  
> > > +/**
> > > + * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
> > > + *
> > 
> > You shouldn't have an empty line in the comment here
> I was trying to follow the style of this file. All other functions start
> like this, including an empty line. Do you want me to:
> a) follow your indication and leave all other functions as they are?
> b) Change all functions docs to follow your suggestion?
> c) leave it as-is?
> 
> Please, advise.

Please see Documentation/doc-guide/kernel-doc.rst

"Function parameters
~~~~~~~~~~~~~~~~~~~

Each function argument should be described in order, immediately following
the short function description.  Do not leave a blank line between the
function description and the arguments, nor between the arguments."

Note the last sentence - there should _not_ be a blank line, so please
follow this for new submissions. I don't think we care enough to fix
what's already there though.

> 
> > 
> > > + * @phydev: the phy_device struct
> > > + * @plca_cfg: where to store the retrieved configuration
> > 
> > Maybe have an empty line, followed by a bit of text describing what this
> > function does and the return codes it generates?
> Again, I was trying to follow the style of the docs in this file.
> Do you still want me to add a description here?

Convention is a blank line - as illustrated by the general format
in the documentation file I refer to above.

> 
> > 
> > > + */
> > > +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> > > +			     struct phy_plca_cfg *plca_cfg)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!phydev->drv) {
> > > +		ret = -EIO;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (!phydev->drv->get_plca_cfg) {
> > > +		ret = -EOPNOTSUPP;
> > > +		goto out;
> > > +	}
> > > +
> > > +	memset(plca_cfg, 0xFF, sizeof(*plca_cfg));
> > > +
> > > +	mutex_lock(&phydev->lock);
> > 
> > Maybe move the memset() and mutex_lock() before the first if() statement
> > above? 
> Once more, all other functions in this file take the mutex -after-
> checking for phydev->drv and checking the specific function. Therefore,
> I assumed that was a safe thing to do. If not, should we fix all of
> these functions in this file?

This is a review comment I've made already, but you seem to have ignored
it. Please ensure that new contributions are safe. Yes, existing code
may not be, and that's something we should fix, but your contribution
should at least be safer than the existing code.

> > Maybe the memset() should be done by plca_get_cfg_prepare_data()?
> I put the memset there when the function was exported. Since we're not
> exporting it anymore, we can put it in the _prepare() function in plca.c
> as you suggest. I just wonder if there is a real advantage in doing
> this?

... because of what I said in the following line below.

> 
> > Wouldn't all implementations need to memset this to 0xff?
> It actually depends on what these implementations are trying to achieve.
> I would say, likely yes, but not necessairly.

Why wouldn't they want this initialisation, given that the use of
negative values means "not implemented" - surely we want common code
to indicate everything is not implemented until something writes to
the parameter?

What if an implementation decides to manually initialise each member
to -1 and then someone adds an additional field later (e.g. for that
0x0A) ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
