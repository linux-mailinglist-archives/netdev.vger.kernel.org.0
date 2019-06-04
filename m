Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FBB351C9
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDVYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:24:08 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:43212 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:24:08 -0400
Received: by mail-ed1-f51.google.com with SMTP id w33so2492921edb.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cj6Zzy70tuFk3/idpGacVghZIbe4TeiKwUgEtcER/Vw=;
        b=GgsZvkJb5a5DkbmHQIPsqN48o4ZF6HQ0o59DMYaMQDR6K03gIX//bF3qKdILXRlUWZ
         PygDifhHYJCCht64w9mmPrKMryaJZKfKN8Hm3fU86OdgNpi5fKDZFO/Sd3UZ5mV1Vdx7
         05hG3MF3ypJZ1Rz5iU4k8urqw6OZjpPfgBpwRa8+5bk0BbivcRU/v9w5Udhe6qwvATlw
         1GBIKUd6r9wlPDGWuMrkE7X+geoed0NxwjOcCIbY5qWTP6OartpAqp42vn0+IKEmIQjI
         w0SOV5Tj47WbFMEw29mIGcT6h+CrPck+qbhDOVzDVWIIERfTf4zFB0+xX0pzWmqMdx7F
         OIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cj6Zzy70tuFk3/idpGacVghZIbe4TeiKwUgEtcER/Vw=;
        b=cUlMm5eo7Y3S8sJGv/cllSvcrgnNTdDG2AfIM6L8r9k0ZHAqNG4Rd+p89xPqVURY8r
         zaswvLd7kBLaGdHVoMeVXolH9J54Uo5vjwslLdV8rJ4K79ofUlZixFnTWNHL/4utUXle
         Ipk7Rdd+E0gAr9OrdAitNl2Y2V4+P6yC3NI3zD7x9wIFM2l/ULo4NQf5PkV0RQAPOc8U
         lr3n4M1xn3JCqhjak7jgMWwRoE7Aa5hkdsDZ/XUJ8RGGjyGTNvF+6+LxyCY9l4kZbav7
         iXt4hsqIGy5+XWUEclbnrY3TE4SdJh4BqavcfTAdMAmBBDgOOGYDlSUd/s9s1GBzEzm4
         tj/Q==
X-Gm-Message-State: APjAAAWiOxCZLon+tnbMg72wO20jCapwlPlWwSWSzuGIPoHpj97s+7Tr
        5MpZAtLpngI3pyioH/cmoJ0W3JThLXJNQAH3UMY=
X-Google-Smtp-Source: APXvYqxbe/l+D6j0KNpsY7HIcQYejU3VdybqnpZcJpqkLNzCsSOVcygo5Qga8XtLchL+PrCCFqxvowpTH3mDc/ElACQ=
X-Received: by 2002:aa7:d30a:: with SMTP id p10mr24939739edq.123.1559683446474;
 Tue, 04 Jun 2019 14:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <5b1c1578-bbf9-8f8c-6657-8f1cceb539d1@gmail.com>
In-Reply-To: <5b1c1578-bbf9-8f8c-6657-8f1cceb539d1@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 00:23:55 +0300
Message-ID: <CA+h21hqpTfnsw2f=fyB=6bEoBikvgD2Pb2WxCb9q6zRbHsaNnw@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 23:55, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 04.06.2019 22:42, Vladimir Oltean wrote:
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
> > of .suspend, the PHY library automatically calls genphy_suspend. Oh
> > well, looks like it doesn't. So of course, phy_stop calls phy_suspend
> > too.
> > But now the second question: between a phy_connect and a phy_start,
> > shouldn't the PHY be suspended too? Experimentally it looks like it
> > still isn't.
> > By the way, Florian, yes, PHY drivers that use WOL still set
> > BMCR_ISOLATE, which cuts the MII-side, so that's ok. However that's
> > not the case here - no WOL.
> >
> Right, some PHY driver callbacks fall back to the generic functionality,
> for the suspend/resume callbacks that's not the case.
> phy_connect() eventually calls phy_attach_direct() that has a call to
> phy_resume(). So your observation is correct, phy_connect() wakes the
> PHY. I'm not 100% sure whether this is needed because also phy_start()
> resumes the PHY.
>

Thanks Heiner!
Looks like replacing the phy_resume() from phy_attach_direct with
phy_suspend() does what I want it to.

> BMCR_ISOLATE isn't set by any phylib function. We just have few
> calls where BMCR_ISOLATE is cleared as part of the functionality.
>
> > Regards,
> > -Vladimir
> >
> Heiner

-Vladimir
