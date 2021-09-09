Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1E3404892
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhIIKj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhIIKj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 06:39:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D171AC061575;
        Thu,  9 Sep 2021 03:38:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g22so1982065edy.12;
        Thu, 09 Sep 2021 03:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5gR95FL0bNqWsIc3Mx8pQM9Kqyqd1pyBM+9i6LA1yo=;
        b=EpfaA+Wt5mfjunDbQ77bCdBqutmQIo2g6+eyk8xJ6rB1LN8mKNt7mN9C63nGwdCAPN
         ZFTDIpabsPiCPv1TbL/I8FARuZny864jJ0Fi6Ap5RaQMkCLQVneKJ9rVZemLDzrzyV3c
         UtbpR1kTXcdm3dUYYbJXfJdq8+uGndjrtQPhd6u6UfCYVf/+kQeO7FytmhWI/x+5/cG1
         OGqo+4iEJ14Ir+tlGWnPiVmiNLvtlT9HqKpHf8Et3/wyiXUUCi7Pni9q8HnD4aJ7rv9p
         o8rdwZUesAfl6LSeQZFD7XJplyQEISn1j0HAbONi+sfK+yO2aNq/ZKWhQn0CecSuqpxN
         AlZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v5gR95FL0bNqWsIc3Mx8pQM9Kqyqd1pyBM+9i6LA1yo=;
        b=fUXEmQTRnU4AzjcSPRVy6+bK5R+FsP4G5W36SQntED5HtckFfAODWq+9f43Oeox7gA
         pQA4SJXC9aDR6NspD9g5sBEFk4Kr+QwSvVh1cpknbssjlZsGHxdHW1SM/4F8Ab5hnQzn
         Tp76lVCTnUkeBnnXFuPet+R+JX9OvKrb+Tsejq1TrhS5shvQ5EIEU/GFSoSqFUw4bvbg
         HkAXc4WgVs1OAixm5Kg7OdyJUef0hf0cAUrP/DutLZ5SXBkkhFQ3dF4aahP2czetbJcj
         gRUv2R9bhGGoWO2H7G82i0n84fhCtZuocmNQKkN+RclD4XZpQ33dzgR41FFlal9rOnys
         inig==
X-Gm-Message-State: AOAM5305b8D9gaZQBt+OQPJNDjjzqpN0Vm2/YW45ngh9n2SRUKqsQrkr
        NKB5CYT5ykJyi59Z/NtF9Eg=
X-Google-Smtp-Source: ABdhPJyV3HJKRdkARVGVfRGsHsFY4wQcBBINVpNmb0P/ZVkAzOWjLbD7L31FnYqGicJNhWbWyWmQbg==
X-Received: by 2002:aa7:c884:: with SMTP id p4mr2384124eds.203.1631183897267;
        Thu, 09 Sep 2021 03:38:17 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d22sm733316ejk.5.2021.09.09.03.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 03:38:16 -0700 (PDT)
Date:   Thu, 9 Sep 2021 13:38:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <20210909103815.kcrygpfssvucbex4@skbuf>
References: <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YTll0i6Rz3WAAYzs@lunn.ch>
 <CAGETcx_U--ayNCo2GH1-EuzuD9usywjQm+B57X_YwFOjA3e+3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_U--ayNCo2GH1-EuzuD9usywjQm+B57X_YwFOjA3e+3Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 08:21:05PM -0700, Saravana Kannan wrote:
> > But with that fixed, it
> > still does not work. This is too late, the mdio busses have already
> > been registered and probed, the PHYs have been found on the busses,
> > and the PHYs would of been probed, if not for fw_devlink.
> 
> Sigh... looks like some drivers register their mdio bus in their
> dsa_switch_ops->setup while others do it in their actual probe
> function (which actually makes more sense to me).

If it makes more sense to you for of_mdiobus_register to be placed in
the probe function and not in ->setup, then please be aware of my
previous email pointing out that DSA defers probe due to other reasons
too before calling ->setup, like of_find_net_device_by_node not finding
the DSA master. If the MDIO bus was registered by then, it will be
destroyed by the unwind path and the device links will not be created a
second time, effectively defeating fw_devlink.

> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 53f034fc2ef7..7ecd910f7fb8 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -525,6 +525,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >             NULL == bus->read || NULL == bus->write)
> >                 return -EINVAL;
> >
> > +       if (bus->parent && bus->parent->of_node)
> > +               bus->parent->of_node->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> > +
> >         BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
> >                bus->state != MDIOBUS_UNREGISTERED);
> >
> > So basically saying all MDIO busses potentially have a problem.
> >
> > I also don't like the name FWNODE_FLAG_BROKEN_PARENT. The parents are
> > not broken, they work fine, if fw_devlink gets out of the way and
> > allows them to do their job.
> 
> The parent assuming the child will be probed as soon as it's added is
> a broken expectation/assumption. fw_devlink is just catching them
> immediately.

It's not really a broken expectation when you come to think of the fact
that synchronous probing is requested, and this is the internal PHY of
the switch we are talking about, not just any PHY off the street, with
random dependencies. It is known beforehand, and so are the dependencies.
All dependencies that the internal PHY has should be provided by the
switch driver by the time it registers the MDIO bus.

The system is not prepared to handle an -EPROBE_DEFER simply because
there is no good reason why it should happen.

I see fw_devlink as injecting a fault in this case. Maybe we should
treat it, but in any case it is adding a pointless -EPROBE_DEFER when
the PHY driver could have probed immediately. This will slow down the
boot time when we treat it properly eventually.

> Having said that, this is not the hill either of us should choose to
> die on. So, how about something like:
> FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
> 
> If that works, I can clean up the series with this and the MDIO fix
> you mentioned.

I'm okay with the "needs child bound on add" name.

> > You also asked about why the component framework is not used. DSA has
> > been around for a while, the first commit dates back to October
> > 2008. Russell Kings first commit for the component framework is
> > January 2014. The plain driver model has worked for the last 13 years,
> > so there has not been any need to change.
> 
> Thanks for the history on why it couldn't have been used earlier.
> 
> In the long run, I'd still like to fix this so that the
> dsa_tree_setup() doesn't need the flag above. I have some ideas using
> device links that'll be much simpler to understand and maintain than
> using the component framework. I'll send out patches for that (not
> meant for 5.15) later and we can go with the MDIO bus hammer for 5.15.

Details?

I am not too fond of using the component framework because I am not
convinced we should be fabricating struct devices we do not need, just
to comply with an API that solves a fabricated problem.
