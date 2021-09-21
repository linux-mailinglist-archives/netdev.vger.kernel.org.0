Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7E41370F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhIUQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhIUQQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 12:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74E886109E;
        Tue, 21 Sep 2021 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632240920;
        bh=1OcDUDp4V1+QymikFDzoyz2VHdUFi0HBrrsglclA4rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=or7E7TnrO94+PUSne0q3bh8w2zgOciUTMLktyPpqOYzHC36owxqsle4DzD0KiEnlL
         7LjBJXybwipQSDUqRZ74tjoySc+FbEgQGkrXjrZcZCVPb3tvwP8uBSlK77R24QlIGE
         sYAdPkL5nYbVBcf6+4O7Z145f6O28btdHV2fNE4M=
Date:   Tue, 21 Sep 2021 18:15:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
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
Message-ID: <YUoFFXtWFAhLvIoH@kroah.com>
References: <20210915170940.617415-1-saravanak@google.com>
 <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUaPcgc03r/Dw0yk@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 03:16:34AM +0200, Andrew Lunn wrote:
> > > diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> > > index 59828516ebaf..9f4ad719bfe3 100644
> > > --- a/include/linux/fwnode.h
> > > +++ b/include/linux/fwnode.h
> > > @@ -22,10 +22,15 @@ struct device;
> > >   * LINKS_ADDED:        The fwnode has already be parsed to add fwnode links.
> > >   * NOT_DEVICE: The fwnode will never be populated as a struct device.
> > >   * INITIALIZED: The hardware corresponding to fwnode has been initialized.
> > > + * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
> > > + *                          driver needs its child devices to be bound with
> > > + *                          their respective drivers as soon as they are
> > > + *                          added.
> > 
> > The fact that this requires so much comment text here is a clear
> > band-aid indication to me.
> 
> This whole patchset is a band aid, but it is for stable, to fix things
> which are currently broken. So we need to answer the question, is a
> bad aid good enough for stable, with the assumption a real fix will
> come along later?

Fix it properly first, don't worry about stable.

But what is wrong with this as-is?  What needs to be done that is not
happening here that you feels still needs to be addressed?

thanks,

greg k-h
