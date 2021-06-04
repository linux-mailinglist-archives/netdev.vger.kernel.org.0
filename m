Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ACA39B417
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFDHkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhFDHkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 03:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 117E961417
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 07:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622792298;
        bh=qgEYwHo8FcZWEmNEe13iGuVcLASdEr/wP96OMWVmmWk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hIyWrpLbx5CkuWKYW4AarAAFezjYzahJMWA0zXioNPjohbMT6pxk8MJlksSZ1PRsa
         y3+aBzatJKhgceyBFcPF3GUfOqH8SGOz7fdM4Hi8PIV9Pewtj4HXCkNO+0m5VDbicL
         kICp6d1v9rIRgwg2TyIblJG8+pe9+ua5W04bDeSZdG9non7xTJpbFROr7ShqzMrRah
         apE5XspBTB1Jqj+b1f+1dMfgQPA91gbhA0gQ3fWY92x4sPOTVZZa6QjBzOgxEhMVPO
         wCeZKZbeXAdn8wCsrkgQsxJrdiTclPntznIg/pgn60nutvBV18Y7dwFzfeCT1DmZlq
         0hCwvaGwIpHEA==
Received: by mail-wr1-f53.google.com with SMTP id z8so8251196wrp.12
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 00:38:17 -0700 (PDT)
X-Gm-Message-State: AOAM533j6MudtLlwYbKY+zLGVsD1vswENPeTZ5tuA4p/dBxAkEU7CUFr
        /k7K/v3KwdqMKgHU9TC9sBAOgYGbCa2rMSJkWTc=
X-Google-Smtp-Source: ABdhPJxE94wDcyW9Ql38CCRiVGdqNY1Gt+/RY+WOwN6nEH+UpRD4O9bnhkhchZs4BHyp3XXZXmUBZ9lpEpGfm7duVRc=
X-Received: by 2002:a5d:530c:: with SMTP id e12mr2353611wrv.165.1622792296713;
 Fri, 04 Jun 2021 00:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 4 Jun 2021 09:36:33 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
Message-ID: <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 8:32 PM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
> On Tue, 1 Jun 2021, Heiner Kallweit wrote:
>
> > > Now I'd like to ask, is quality reliable fix still wanted in mainline or rather not?
> > > Because I'll personally do my best to create/find a good fix anyway, but if it is
> > > of zero interest for mainline, I'll probably not invest much time into communicating
> > > it. My understanding was that default rule is "if broken go fix it" but due to the
> > > age of both code and hardware, maybe it is considered frozen or some such
> > > (I'm just not aware really).
> > >
> > Driver 8139too has no maintainer. And you refer to "mainline" like to a number of developers
> > who are paid by somebody to maintain all drivers in the kernel. That's not the case in general.
> > You provided valuable input, and if you'd contribute to improving 8139too and submit patches for
> > fixing the issue you're facing, this would be much appreciated.
>
>  It's an issue in x86 platform code, not the 8139too driver.  Any option
> card wired to PCI in this system somehow could suffer from it.  Depending
> on how you look at it you may or may not qualify it as a bug though, and
> any solution can be considered a workaround (for a BIOS misfeature) rather
> than a bug fix.

I think it would be good though to reinstate the driver workaround in some way,
regardless of whether the x86 platform code gets changed or not.

From the old linux-2.6.2 code it appears that someone had intentionally
added the loop as a hack to make it work on a broken or misconfigured BIOS.
It's hard to know if that was indeed the intention, but it's clear that the
driver change in 2.6.3 broke something that worked (most of the time)
without fixing it in a better way.

>  The question is IMHO legitimate, and I can't speak for x86 platform
> maintainers.  If I were one, I'd accept a reasonable workaround and it
> does not appear to me it would be a very complex one to address this case:
> basically a PCI quirk to set "this southbridge has ELCR at the usual
> location" (if indeed it does; you don't want to blindly poke at random
> port I/O locations in generic code), and then a tweak to `pirq_enable_irq'
> or `pcibios_lookup_irq' as Arnd has suggested.

(adding the x86 maintainers to Cc, the thread is archived at
 https://lore.kernel.org/netdev/60B24AC2.9050505@gmail.com/)

Changing the x86 platform code as well would clearly help avoid similar
issues with other PCI cards on these broken platforms, but doing it
correctly  seems hard for a couple of reasons.

It sounds like it would have been a good idea 20 years ago when the
broken i486 platforms were still fairly common, but now we don't even
know whether the code was intentional or not. I don't remember a lot of
the specifics of pre-APIC x86, but I do remember IRQ configuration
as a common problem without a single good solution.

There is a realistic chance that other combinations of broken hardware
and drivers rely on the x86 PCI code doing exactly what it does today.
If overriding the BIOS setting breaks something that works today, nothing
is gained, because the next person running into an i486 PCI specific bug
is unlikely to be as persistent and competent as Nikolai in tracking down
the root cause.

Doing a narrower change to a specific chipset, motherboard or BIOS
would be less risky, but would likely miss similar cases. Any x86
specific change would clearly also miss similar problems that may
or may not exist on other architectures.

     Arnd
