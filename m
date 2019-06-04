Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6A351D8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFDV0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:26:37 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:41739 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDV0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:26:37 -0400
Received: by mail-ed1-f43.google.com with SMTP id x25so2525716eds.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=02VI3ULlHhZfsFY1V6FwkdMgxVOyXNKBEM3loz28ZP8=;
        b=saHZmzG4o+EHpPsI2Pt69+qcdZzXZTFQFQX2MvfIpD+20aAmFicZI7JjiymAavtQtf
         ERWbazwgr8uXsGQwxXNI/NMd3wGu6KtzXRrrn4qQv/RZA9NqJxJoKGhy2x01AskCOGq4
         JDGetRme9ITUNA5J2R5u9cr+XtiuEE+WdxPTeT+Fny1tkZ1q+gNhDmAt6TM8Cv1Z303V
         X0JI2qjNe0a15JBiujQ6LYk2uw6I3rSMynn+ib0zmgFYOgNlI1Ry3GMRmp+yuAOrSLqx
         xroug+wkp9++fvCzP14fCxmW/NlKpmSIIZ2g5+ng658y+AEv29hgWk0OaoMyVXzUFUk7
         mOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=02VI3ULlHhZfsFY1V6FwkdMgxVOyXNKBEM3loz28ZP8=;
        b=jDhqfyXA0Qv8cXtZbHPeI89jgrE5yWixYYZUXgi4+m/FdSwUYiflJKpWZ51aWLhs3A
         oRUzpY71Be/Fz5RupqmhAL5ZTx8mXwWpJ73pc/kiz6eCdxh+P1ugLXFGpUUJGD627Uwd
         QfXIEAjFqAeJi9KdWLzrKAV/zdYZlOHxsGI3ys/0nrn6YdgA65/cNsQivkuSjIJveAnT
         Ej7ANRdF13sa4tHAsdlVK9YqbQYC/NXnHF3RXu4/eV6b+AKkvl3syMm++c86Iy7d5Wiy
         db030LK4VUEKVMuG07LCyQ6F6OUZbtQh1goDkTisbOuQdRfM8BCA7xL2T6DGUjk7hibY
         g+bg==
X-Gm-Message-State: APjAAAXoA2jYOmvUO62SPQk0p3mWQLmN5M5WAnL3RhT47jFSf7491j0i
        oj92Dr3Kmb5z4MAPEo4qTnY7X9Qh3kLdUm8rewo=
X-Google-Smtp-Source: APXvYqw+DV/ONY/rEl2Eh7NdJaA/3TxLEDzV+9kgFVgDe+Q4VijLQNsLfgaMTeeX1dIGzCsUte2XbayqT6ww3CSgtow=
X-Received: by 2002:a17:906:4e8f:: with SMTP id v15mr549992eju.47.1559683595591;
 Tue, 04 Jun 2019 14:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <13123dca-8de8-ac1d-9b21-4588571150f3@gmail.com>
In-Reply-To: <13123dca-8de8-ac1d-9b21-4588571150f3@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 00:26:24 +0300
Message-ID: <CA+h21hqd6brXA+b1jjp6sFFmkXCvfKMi6dpWqHp=p8eQphEubg@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 23:57, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 6/4/2019 1:42 PM, Vladimir Oltean wrote:
> > On Tue, 4 Jun 2019 at 23:07, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
> >>> Hi,
> >>>
> >>> I've been wondering what is the correct approach to cut the Ethernet link
> >>> when the user requests it to be administratively down (aka ip link set dev
> >>> eth0 down).
> >>> Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.
> >>> This leaves an Ethernet link between the PHY and its link partner.
> >>> The Freescale gianfar driver (authored by Andy Fleming who also authored the
> >>> phylib) does a phy_disconnect here. It may seem a bit overkill, but of the
> >>> extra things it does, it calls phy_suspend where most PHY drivers set the
> >>> BMCR_PDOWN bit. Only this achieves the intended purpose of also cutting the
> >>> link partner's link on 'ip link set dev eth0 down'.
> >>
> >> Hi Vladimir
> >>
> >> Heiner knows the state machine better than i. But when we transition
> >> to PHY_HALTED, as part of phy_stop(), it should do a phy_suspend().
> >>
> >>    Andrew
> >
> > Hi Andrew, Florian,
> >
> > Thanks for giving me the PHY_HALTED hint!
> > Indeed it looks like I conflated two things - the Ehernet port that
> > uses phy_disconnect also happens to be connected to a PHY that has
> > phy_suspend implemented. Whereas the one that only does phy_stop is
> > connected to a PHY that doesn't have that... I thought that in absence
> > of .suspend, the PHY library automatically calls genphy_suspend.
>
> It does not fallback to genphy_suspend(), maybe we should change that,
> setting BMCR.PDOWN is a good power saving in itself, if the PHY can do
> more, you have to implement a .suspend() callback to get the additional
> power savings.
>
> > Oh well, looks like it doesn't. So of course, phy_stop calls phy_suspend
> > too.
> > But now the second question: between a phy_connect and a phy_start,
> > shouldn't the PHY be suspended too? Experimentally it looks like it
> > still isn't.
> > By the way, Florian, yes, PHY drivers that use WOL still set
> > BMCR_ISOLATE, which cuts the MII-side, so that's ok. However that's
> > not the case here - no WOL.
>
> I was just responding about what is IMHO sensible to do. There is an
> additional caveat/use case to possibly consider which I am sure some
> drivers intentionally support (or not), which is that bringing down the
> interface does stop the PHY state machine and then you are free to issue
> whatever SIO{S,G}MIIREG for diagnostics etc. Whether the MAC or PHYLIB
> is responsible for taking the PHY out of power down mode, or if it is up
> to the diagnostics software to do that is up for debate, I would go with
> the latter, which would always work regardless of what you are trying to do.

Well in that case the "diagnostics software" (we're probably all
looking at phytool) should just unset the ISOLATE/PDOWN bits...
The netdev is still going to have carrier off either way...

> --
> Florian

-Vladimir
