Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4ED1822F6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgCKT7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:59:31 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46940 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCKT7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:59:30 -0400
Received: by mail-ed1-f66.google.com with SMTP id ca19so4392541edb.13
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 12:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LfF4RnkkEuzs5MYMqdO+D2HQ8LUmrlIKs0NRiXXJShk=;
        b=snSTRMZwBOMV9IsK3ozdFyW/RpjckiZxTztJySPuTuxCb8eoMl7K2F/BtFWwgk2cXw
         5+jnW9RbFK2gy0ogvpVDfm/5s/+cg/BzwPCiiXl4KxNoxgQ7SV5Kp0QE6bZc33XFG7R7
         c/CiBH1x2M0XdB9Q2gG3eQlvw/HstGwW8txDPwMrt2gB+MkFUzI5gCLITecA4zi0fWS4
         kP60ugDJKGQ2Kpu3RoQPfDyVuMm4HICDKMbZP/6lDtNTb24G/TO6xaMF6yqRlXWTj6KK
         8gGg7qMYE49sT1Io75gf97oA6dNwlZ8EeUWEguw3CgkTiz9wrnvZCOdo6i5TQvyyoze6
         XSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LfF4RnkkEuzs5MYMqdO+D2HQ8LUmrlIKs0NRiXXJShk=;
        b=LzFVxZ9fa6rIhs+UHJ/Aksi5vbie6zjPcgIxmxdaRDW9rtecWrP8S+CyQ0UnHxKy3l
         vyaPT5EjeWzu9hz6ikbZmG+9VjvIHXuz6Y63zdSgyVxTmJl5qHtCSuWP68WW2SC2+E2d
         3HVn1AJvfQ5izIOkwc7Y1lZn4s0p5o/gt/NBtrxeJ6zEcADrdX8BYzoZFZ13LrbsdFqD
         T+BiFBm7xYhZ7s3SC+dQeHMTSx9Ss9cPgA8WwPPqLXE307UFNPcP81BU0dyaD7oX8oSs
         sLnfjgDPbMuZlJTIHAuR+SujtT/gkjzc8f8EMiN6J1gcOJ4EfZFEeLZWFHhSGpgvgGO5
         S9Pg==
X-Gm-Message-State: ANhLgQ0m0r5NpduAlE5wnfsKNVkRBBVpo7E4Yg6gRhuVwQgQkE5CUqX8
        jrcf13GGTcPsOWgY/3DcSKSklptMi9JGv2UOpr0=
X-Google-Smtp-Source: ADFU+vvS5p6ZqjuU+U6ikVji6QMNrb3ibarAHChdQKY0ll0tZUvt6TfqBPM2ohHRSRZjDD6w9dWarYRiyzp7/FUwhCc=
X-Received: by 2002:a17:906:e91:: with SMTP id p17mr3785918ejf.239.1583956769008;
 Wed, 11 Mar 2020 12:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com>
 <20200311170918.GQ25745@shell.armlinux.org.uk> <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
 <20200311193223.GR25745@shell.armlinux.org.uk>
In-Reply-To: <20200311193223.GR25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 21:59:18 +0200
Message-ID: <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phylink: pcs: add 802.3 clause 22 helpers
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 at 21:32, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>

>
> So, why abuse some other subsystem's datastructure for something that
> is entirely separate, potentially making the maintanence of that
> subsystem more difficult for the maintainers?  I don't get why one
> would think this is an acceptable approach.
>
> What you've said is that you want to use struct phy_device, but you
> don't want to publish it into the device model, you don't want to
> use mdio accesses, you don't want to use phylib helpers.  So, what's
> the point of using struct phy_device?  I don't see _any_ reason to
> do that and make things unnecessarily more difficult for the phylib
> maintainers.
>

So if it's such a big mistake...

> > > Sorry, but you need to explain better what you would like to see here.
> > > The additions I'm adding are to the SGMII specification; I find your
> > > existing definitions to be obscure because they conflate two different
> > > bit fields together to produce something for the ethtool linkmodes
> > > (which I think is a big mistake.)
> >
> > I'm saying that there were already LPA_SGMII definitions in there.
> > There are 2 "generic" solutions proposed now and yet they cannot agree
> > on config_reg definitions. Omitting the fact that you did have a
> > chance to point out that big mistake before it got merged, I'm
> > wondering why you didn't remove them and add your new ones instead.
> > The code rework is minimal. Is it because the definitions are in UAPI?
> > If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
> > would user space care about the SGMII config_reg? There's no user even
> > of the previous SGMII definitions as far as I can tell.
>
> I don't see it as a big deal - certainly not the kind of fuss you're
> making over it.
>

...why keep it?
I'm all for creating a common interface for configuring this. It just
makes me wonder how common it is going to be, if there's already a
driver in-tree, from the same PCS hardware vendor, which after the
patchset you're proposing is still going to use a different
infrastructure.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Thanks,
-Vladimir
