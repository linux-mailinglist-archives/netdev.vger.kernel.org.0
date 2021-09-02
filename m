Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BC53FF415
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347372AbhIBTYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbhIBTYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:24:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92489C061575;
        Thu,  2 Sep 2021 12:23:42 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id n11so4503515edv.11;
        Thu, 02 Sep 2021 12:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XycNEiMM7ucnINeY0jm+nAgwWJbB54F/7fLn2e85cfs=;
        b=g+EIiwjT6fLtYE+i4cXr/ItzvsVPLGTZ8O3hYgDVWG/s4CspG2LenK8YxDFzc8+yCt
         WZite/2ebffZlkHpHhZNie0O4KBwkkE9Db3yYilAHNZ3cI5NsSP4M0u3fGspu2AyXErB
         nZ+TVEJmrT/kJhGJ6nPFHtqkjkCC9DcfuytDJ9o0sPLYNlfES/C8YYmlNjr7prgsTU+/
         Fjhdj3pmjSwbQmVJ3L2pM4rjJBdJwLI9tLH5/5VjwdopZFm4R/O2Q3hR8Uw9qzb0Je3m
         YiWYNPTIV7BuYiRe+f9qgLU1rVQPGfLX3NSiIhRL6smy/MCNBDjexTnLM604GzYKaNjR
         v2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XycNEiMM7ucnINeY0jm+nAgwWJbB54F/7fLn2e85cfs=;
        b=I2bixp1LWhyE49dIHVJKyvOe6J0x9Zuq7AtRclpn3SpOQMCWWFCVwOtMnInTQZ3JRz
         tP6MiyEeQ3gFvUtcWtzOjclCQMSW9Wqx/vix6w9TGojXiZp28Ew5NBB3h0MIPS85vNYl
         2WwYuBPz1z/yRggCyuXhu6jsbH4CkVgdNUzvoh88vscea+fdqDoOyH2lIK8oAz04n9UE
         waGVzgJJEBEZVadfOStOWGZaAYsJkg+Ie/OsVvPnRiBBJDnFfSopAJr911DCUNDcMEaA
         cOnTCgYqai7pjn4SW2s2QtFiTb360RCtRHNFNzDL/S6tWiAdJ2mRF2omy1H4GchsJ4xI
         +VHQ==
X-Gm-Message-State: AOAM532iPbiRUskKbYZm27q6hvsPF2JemC/YRxLnhW7HFQXYraCVfEZy
        NXiquqBcwbfy97d8JEmOaBc=
X-Google-Smtp-Source: ABdhPJyNV6JIpwIy589Hn5okAJ6g3pjBibjPPQxO1mr00BjUJMxDMlI2W+m6DcL+kAjrjuyRcUk6pg==
X-Received: by 2002:aa7:c884:: with SMTP id p4mr4936443eds.203.1630610621096;
        Thu, 02 Sep 2021 12:23:41 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id se22sm1635222ejb.32.2021.09.02.12.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:23:40 -0700 (PDT)
Date:   Thu, 2 Sep 2021 22:23:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902192338.trajegyxh76fjci4@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902185016.GL22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 07:50:16PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 52310df121de..2c22a32f0a1c 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >  
> >  	/* Assume that if there is no driver, that it doesn't
> >  	 * exist, and we should use the genphy driver.
> > +	 * The exception is during probing, when the PHY driver might have
> > +	 * attempted a probe but has requested deferral. Since there might be
> > +	 * MAC drivers which also attach to the PHY during probe time, try
> > +	 * harder to bind the specific PHY driver, and defer the MAC driver's
> > +	 * probing until then.
> >  	 */
> >  	if (!d->driver) {
> > +		if (device_pending_probe(d))
> > +			return -EPROBE_DEFER;
> 
> Something else that concerns me here.
> 
> As noted, many network drivers attempt to attach their PHY when the
> device is brought up, and not during their probe function.
> 
> Taking a driver at random:
> 
> drivers/net/ethernet/renesas/sh_eth.c
> 
> sh_eth_phy_init() calls of_phy_connect() or phy_connect(), which
> ultimately calls phy_attach_direct() and propagates the error code
> via an error pointer.
> 
> sh_eth_phy_init() propagates the error code to its caller,
> sh_eth_phy_start(). This is called from sh_eth_open(), which
> probagates the error code. This is called from .ndo_open... and it's
> highly likely -EPROBE_DEFER will end up being returned to userspace
> through either netlink or netdev ioctls.
> 
> Since EPROBE_DEFER is not an error number that we export to
> userspace, this should basically never be exposed to userspace, yet
> we have a path that it _could_ be exposed if the above condition
> is true.
> 
> If device_pending_probe() returns true e.g. during initial boot up
> while modules are being loaded - maybe the phy driver doesn't have
> all the resources it needs because of some other module that hasn't
> finished initialising - then we have a window where this will be
> exposed to userspace.
> 
> So, do we need to fix all the network drivers to do something if
> their .ndo_open method encounters this? If so, what? Sleep a bit
> and try again? How many times to retry? Convert the error code into
> something else, causing userspace to fail where it worked before? If
> so which error code?

It depends what is the outcome you're going for.
If there's a PHY driver pending, I would do something to wait for that
if I could, it would be silly for the PHY driver to be loading but the
PHY to still be bound to genphy.

I feel that connecting to the PHY from the probe path is the overall
cleaner way to go since it deals with this automatically, but due to the
sheer volume of drivers that connect from .ndo_open, modifying them in
bulk is out of the question. Something sensible needs to happen with
them too, and 'genphy is what you get' might be just that, which is
basically what is happening without these patches. On that note, I don't
know whether there is any objective advantage to connecting to the PHY
at .ndo_open time.

> 
> I think this needs to be thought through a bit better. In this case,
> I feel that throwing -EPROBE_DEFER to solve one problem with one
> subsystem can result in new problems elsewhere.
> 
> We did have an idea at one point about reserving some flag bits in
> phydev->dev_flags for phylib use, but I don't think that happened.
> If this is the direction we want to go, I think we need to have a
> flag in dev_flags so that callers opt-in to the new behaviour whereas
> callers such as from .ndo_open keep the old behaviour - because they
> just aren't setup to handle an -EPROBE_DEFER return from these
> functions.

Or that, yes. I hadn't actually thought about using PHY flags, but I
suppose callers which already can cope with EPROBE_DEFER (they connect
from probe) can opt into that.
