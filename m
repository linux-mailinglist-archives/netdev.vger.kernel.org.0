Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A7E410908
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhISBSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 21:18:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhISBSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 21:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=toGy0eeronL8ztqB49+haoMucITk/GOL/Fh2CzRXSD4=; b=hVRH4o1YLVKCKJln+fRBwsXHg5
        PuTC81a1lAunb9blTdkRvyXUOCEp1FL1/IqKFaqxI6I/zFutdkRYf9psEvKfh2qotaYZRhWxpDjK2
        4HDS/UkU49DtYDZ+iRkSYyPt9+f0E41MxthF0zNjraplxvAZsEV39C6G9R1ZsLw7MrZw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRlRa-007HXJ-Gw; Sun, 19 Sep 2021 03:16:34 +0200
Date:   Sun, 19 Sep 2021 03:16:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUaPcgc03r/Dw0yk@lunn.ch>
References: <20210915170940.617415-1-saravanak@google.com>
 <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> > index 59828516ebaf..9f4ad719bfe3 100644
> > --- a/include/linux/fwnode.h
> > +++ b/include/linux/fwnode.h
> > @@ -22,10 +22,15 @@ struct device;
> >   * LINKS_ADDED:        The fwnode has already be parsed to add fwnode links.
> >   * NOT_DEVICE: The fwnode will never be populated as a struct device.
> >   * INITIALIZED: The hardware corresponding to fwnode has been initialized.
> > + * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
> > + *                          driver needs its child devices to be bound with
> > + *                          their respective drivers as soon as they are
> > + *                          added.
> 
> The fact that this requires so much comment text here is a clear
> band-aid indication to me.

This whole patchset is a band aid, but it is for stable, to fix things
which are currently broken. So we need to answer the question, is a
bad aid good enough for stable, with the assumption a real fix will
come along later?

     Andrew
