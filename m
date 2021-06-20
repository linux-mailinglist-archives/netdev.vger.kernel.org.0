Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15A3ADDF3
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 12:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhFTKYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 06:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhFTKYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 06:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC8F560724
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624184530;
        bh=ftS+O1GYUAjHsJmhwOlgLDVIWYOerkRtSVIFT5oVpbM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ExbNxazJ49Si7A2uOJ+BVjd67Xfb2vlr9jn1lLCxxCvKmf0O3nEgjgSAnsxZW2RGU
         G5bx1e2ej3YeJB6msgyNkYVNpfhwCbSLPANAzCBpNe3/xvb75CNJa/nN2wuB4a2PW/
         Se7iXzaW6M6jw5bIM6YViO/nwCXdrYTgquVrOuy8UJrZphQT6E6prnzi+f8fvGukTG
         7XPLaGmRfXDmjpkSRB+LC1dvk7KNVS2HC9fA+ZXuypioeFdofHKuQJCihXVj6bYurl
         jEwkblz23h0uDW7jmkuW0OjtvqRXMiTRh9941tArlHpX2cjizKEOY0CyZB7U4qW863
         O9eS0oZYUF4jg==
Received: by mail-wr1-f45.google.com with SMTP id c5so16088675wrq.9
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 03:22:10 -0700 (PDT)
X-Gm-Message-State: AOAM531Ww8fk69JQZrqkFqWJaocuflDYxiXdk30FfiVCOoYcfD/7LbfZ
        Uvw8QewT3bOxP7H+WHKc3q2GmEl+QVlFmb8NgZw=
X-Google-Smtp-Source: ABdhPJzuJ5ri62jRB0rGdTr2gIPW4OvEOQlAdu5Dut3bcjvGARPcqZgS7iXJRZ4V8hqfSnYXRAPSDdSSNJvXHgk5eRs=
X-Received: by 2002:a05:6000:1561:: with SMTP id 1mr22380188wrz.165.1624184529387;
 Sun, 20 Jun 2021 03:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de>
In-Reply-To: <877dipgyrb.ffs@nanos.tec.linutronix.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 20 Jun 2021 12:19:54 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2YAATZh_oBj3dKY5C_76aWnGtG4+cdnDt1CfzH5f3tXA@mail.gmail.com>
Message-ID: <CAK8P3a2YAATZh_oBj3dKY5C_76aWnGtG4+cdnDt1CfzH5f3tXA@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 2:37 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, Jun 04 2021 at 09:36, Arnd Bergmann wrote:
> > There is a realistic chance that other combinations of broken hardware
> > and drivers rely on the x86 PCI code doing exactly what it does today.
>
> Legacy PCI interrupts are specified as being level triggered because
> legacy PCI requires to share interrupts and you cannot share edge
> triggered interrupts reliably. PCI got a lot of things wrong, but this
> part is completely correct.
>
> From experience I know that 8139 depends on that and I debugged that
> myself many years ago on an ARM system which had the trigger type
> configuration wrong.
>
> Let me clarify why this breaks first. The interesting things to look at
> are:
>
>   - the device internal interrupt condition which in this case are
>     package received or transmitted and status change
>
>   - the interrupt line
>
> Let's look at the timing diagram of simple RX events:
>
>            ___________________               _____...
> RX     ___|                   |_____________|
>
>             ___________________               ____...
> INTA   ____|                   |_____________|
>
>               _ INT handler _____ RETI _        __...
> Kernel ______|                          |______|
>
> Trivial case which works with both edge and level. Now let me add TX
> complete for the level triggered case:
>
>            ___________________
> RX     ___|                   |_____________
>
>                              _______________
> TX     _____________________|
>
>             ________________________________
> INTA   ____|
>
>               _ INT handle RX ___ RETI_   __ INT handle TX
> Kernel ______|                         |_|
>
> Works as expected. Now the same with edge mode on the i8259 side:
>
>            ___________________
> RX     ___|                   |_____________
>
>                              _______________
> TX     _____________________|
>
>             ________________________________
> INTA   ____|
>
>               _ INT handle RX ___ RETI_
> Kernel ______|                         |_____ <- FAIL
>
>
> Edge mode loses the TX interrupt when it arrives before the RX condition
> is cleared because INTA will not go low.

Right, that is what I concluded as well.

> The driver cannot do anything about it reliably because all of this is
> asynchronous. The loop approach is a bandaid and kinda works, but can it
> work reliably? No. Aside of that it's curing the symptom which is the
> wrong approach.
>
> The only reasonable solution to this is to enforce level even if that
> BIOS switch says otherwise.

I think the hack that Nikolai implemented based on my suggestion
should work around this reliably though: All events (RX, TX, and others)
are now masked in the hardirq handler but processed and acked inside
the napi poll function. After it has processed all events, the device unmasks
all events, so if a new event is already pending at this time, the IRQ line
gets raised and will correctly be processed in both edge and level
mode.

Am I missing something here?

Obviously it's just a hack and it's still going to fail if the edge interrupt
is actually shared with another device, but I don't see any downside
in changing the driver that way.

> > If overriding the BIOS setting breaks something that works today, nothing
> > is gained, because the next person running into an i486 PCI specific bug
> > is unlikely to be as persistent and competent as Nikolai in tracking down
> > the root cause.
>
> Yes, sigh. The reason why this BIOS switch exists, which should have
> never existed, is that during the transition from EISA which was edge
> triggered to PCI some card manufacturers just changed the bus interface
> of their cards but completely missed the edge -> level change in
> hardware either by stupidity or intentionally so they did not have to
> make any changes to the rest of the hardware and to drivers.
>
> The predominant OS'es at that time of course did not have an easy way to
> add a quirk to fix this, so the way out was to add the chicken bit
> option to the BIOS which then either tells the OS the trigger mode for
> INTA..INTD and just sets up ELCR before booting the OS. I have faint
> memories that I had to use such a BIOS switch long time ago to get some
> add-on PCI card working.
>
> So the right thing to do is to leave 8139 as is and add a PCI quirk
> which enforces level trigger type for 8139 in legacy PCI interrupt mode.

So you would prefer a quirk specific to this PCI device on misconfigured
machines? That would at least completely avoid the risk of breaking setups
that rely on an intentional misconfiguration, since it only changes setups
that are definitely not working.

On the other hand, it wouldn't help with non-x86 machines that might
have the same issue, or on x86 machines with a different PCI card
in a misconfigured slot, unless there we maintain a list of PCI
IDs that are known to not work with a broken BIOS configuration.

> Alternatively we can just emit a noisy warning when a legacy PCI
> interrupt is configured as edge by the BIOS and tell people to toggle
> that switch if stuff does not work. Though that might be futile because
> not all BIOSes have these toggle options.

That sounds like a good idea regardless of any other outcome.

       Arnd
