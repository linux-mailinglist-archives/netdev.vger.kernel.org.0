Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8CA2916F5
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJRKf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 06:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgJRKf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 06:35:26 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1B122203
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603017325;
        bh=XJH3xURj6/hvuITHtGrkup9SgapCAbRYZieaXTtQLO0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v7OtStanappHSEUVLDY00VDN4JblTX9DnxYXXaFfirwiJrOmJ23c5Lcb+vRcw3Snn
         xp9g1GSql84/WcXFmNdPhKUnvWuuCtxB22/fFzCVCkJn7fMCV7kSf71vGtxY1Qk4Xp
         ZHCjmwvdd8eQ1A/XZESR5CEZQpzP0MiTo5Eo9S9Q=
Received: by mail-ot1-f52.google.com with SMTP id n15so7683961otl.8
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 03:35:25 -0700 (PDT)
X-Gm-Message-State: AOAM53292nr7mRn3+5RXLy1vXUpZS9AQw0v8YE07ehxG+c7AvRpfwm9U
        7XKUV9/SzyeCNAkCVO95MYcgEu+UafdQEs2vW9k=
X-Google-Smtp-Source: ABdhPJzzUs4B1RfdroAAl3oqI9adWu6b4W4S+2DOau6G1eXNyd7FajuuM7M3CekYRrj0yPjK/VNbWN58SB8gnmAk55g=
X-Received: by 2002:a9d:6c92:: with SMTP id c18mr8445626otr.108.1603017324297;
 Sun, 18 Oct 2020 03:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch> <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch> <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch> <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch>
In-Reply-To: <20201017230226.GV456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 18 Oct 2020 12:35:13 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
Message-ID: <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, steve@einval.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 at 01:02, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Oct 18, 2020 at 12:19:25AM +0200, Ard Biesheuvel wrote:
> > (cc'ing some folks who may care about functional networking on SynQuacer)
> >
> > On Sat, 17 Oct 2020 at 21:49, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > So we can fix this firmware by just setting phy-mode to the empty
> > > > string, right?
> > >
> > > I've never actually tried it, but i think so. There are no DT files
> > > actually doing that, so you really do need to test it and see. And
> > > there might be some differences between device_get_phy_mode() and
> > > of_get_phy_mode().
> > >
> >
> > Yes, that works fine. Fixed now in the latest firmware build [0]
>
> Thanks for reporting back on that. It probably needs to be something
> we always recommend for ACPI systems, either use "", or preferably no
> phy-mode at all, and let the driver default to NA. ACPI and networking
> is at a very early stage at the moment, since UEFA says nothing about
> it. It will take a while before we figure out the best practices, and
> some vendor gets something added to the ACPI specifications.
>

You mean MDIO topology, right? Every x86 PC and server in the world
uses ACPI, and networking doesn't seem to be a problem there, so it is
simply a matter of choosing the right abstraction level. I know this
is much easier to achieve when all the network controllers are on PCIe
cards, but the point remains valid: exhaustively describing the entire
SoC like we do for DT is definitely not the right choice for ACPI
systems. This also means that ACPI is simply not the right fit for all
designs, and we should push back harder against the tick-the-box
exercises that are going on to use ACPI for describing unusual designs
that are never going to boot RHEL or other ACPI-only distros anyway.

> > But that still leaves the question whether and how to work around this
> > for units in the field. Ignoring the PHY mode in the driver would
> > help, as all known hardware ships with firmware that configures the
> > PHY with the correct settings, but we will lose the ability to use
> > other PHY modes in the future, in case the SoC is ever used with DT
> > based minimal firmware that does not configure networking.
> >
> > Since ACPI implies rich firmware, we could make ACPI probing of the
> > driver ignore the phy-mode setting in the DSDT.
>
> I'm O.K. with that, for this driver, but please add a comment in the
> code about why ACPI ignores DSDT, because of older broken firmware.
>

Sure.

> > But if we don't do the same for DT, it would mean DT users are
> > forced to upgrade their firmware, and hopefully do so before
> > upgrading to a kernel that breaks networking.
>
> Nothing new there. As i said, we have been through this before with
> the Atheros PHY and others.
>
> One option would be to move the DT into the kernel and fix it. Most
> distributions already use the DT version shipped with the kernel, so
> they would automatically get the fixed DT at the same time as the
> kernel which needs the fix.
>

The DT is not a flat file that you can simply source from elsewhere -
it is constructed at boot using firmware settings and other data that
is different between systems.


I do have a question about the history here, btw. As I understand it,
before commit f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx
delays config"), the phy-mode setting did not have any effect on
Realtek PHYs in the first place, right? Since otherwise, this platform
would never have worked from the beginning.

So commit f81dadbcf7fd was backported to -stable, even though it
didn't actually work, and had to be fixed in bbc4d71d63549bcd ("net:
phy: realtek: fix rtl8211e rx/tx delay config"), which is the commit
that causes the regression on these boards.

So why was commit f81dadbcf7fd sent to -stable in the first place? It
doesn't have a fixes tag or cc:stable, and given that it is not
actually correct to begin with, there seems to be little justification
for this. Surely, no platform exists in the field that requires this
commit (as it is broken) or the followup fix (since only was never
taken into account before)

In summary, I think that - even if we agree that the way forward is to
fix the firmware and make the driver do the right thing without any
quirks - these patches do not belong in -stable, and should be
reverted, unless anyone can point out a system that was working
before, got broken and was fixed again by f81dadbcf7fd (i.e., a true
regression)
