Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C363ADC2D
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 02:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFTAgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 20:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFTAgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 20:36:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A164AC061574
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 17:34:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624149256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrCYpZdPkrpesNdf9BdrAll3FMyRyNsb57YTMWcV7BM=;
        b=bz9EZ9TgkKK+D3ai8H4edF0r3QKiLNO4JrdFGUkL+8dNNH21XG5b7jo0O7x7gUma/Q6JSi
        j7anOhb3LDkl8ZSVOiX+mgvmP14DWd4D+TkXon6gJ9T6r8WBIhFOMa9k9sJJvX3WomI30y
        4VAnrWHz0aBlJ1oDmfwrJbsmuJ5UwUEQW5CyT5up09iI9r6Gym+FN2j5Nq+S+vjCp8WqRQ
        3l3ykWJOq5SzGRQkjwKyBgUtFp14iPisHjDmhu5BW4oLJ0l/21F8jCUz5zqrPbegI53nbb
        robnSYYrev5mgZd87ixaU1IhT5rTRnzL1MCVTb5ROv5s3ct5HqCvemLhHzdI2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624149256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrCYpZdPkrpesNdf9BdrAll3FMyRyNsb57YTMWcV7BM=;
        b=4V6ltbvskMCvhR/Hl/3DfzffjffeHXOY5y5X7S+1TQaeum/5Q4PORK9vGtX0GGfvBrmOZU
        RYTh5JfbCXyhqNDw==
To:     Arnd Bergmann <arnd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
Date:   Sun, 20 Jun 2021 02:34:16 +0200
Message-ID: <877dipgyrb.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04 2021 at 09:36, Arnd Bergmann wrote:
> On Thu, Jun 3, 2021 at 8:32 PM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>>  It's an issue in x86 platform code, not the 8139too driver.  Any option
>> card wired to PCI in this system somehow could suffer from it.  Depending
>> on how you look at it you may or may not qualify it as a bug though, and
>> any solution can be considered a workaround (for a BIOS misfeature) rather
>> than a bug fix.
>
> I think it would be good though to reinstate the driver workaround in some way,
> regardless of whether the x86 platform code gets changed or not.

Why?

> From the old linux-2.6.2 code it appears that someone had intentionally
> added the loop as a hack to make it work on a broken or misconfigured
> BIOS.

The usual fix the symptom not the root cause approach. So, no.

> It's hard to know if that was indeed the intention, but it's clear that the
> driver change in 2.6.3 broke something that worked (most of the time)
> without fixing it in a better way.
>
>>  The question is IMHO legitimate, and I can't speak for x86 platform
>> maintainers.  If I were one, I'd accept a reasonable workaround and it
>> does not appear to me it would be a very complex one to address this case:
>> basically a PCI quirk to set "this southbridge has ELCR at the usual
>> location" (if indeed it does; you don't want to blindly poke at random
>> port I/O locations in generic code), and then a tweak to `pirq_enable_irq'
>> or `pcibios_lookup_irq' as Arnd has suggested.

Correct. Any legacy PCI interrupt #A..#D must be level triggered. Edge
is simply wrong for those. But of course that's wishful thinking. See
below.

Vs. ELCR: it's documented to be 0x4d0, 0x4d1 and the kernel has it hard
coded. So that's really the least of my worries.

> (adding the x86 maintainers to Cc, the thread is archived at
>  https://lore.kernel.org/netdev/60B24AC2.9050505@gmail.com/)
>
> Changing the x86 platform code as well would clearly help avoid similar
> issues with other PCI cards on these broken platforms, but doing it
> correctly  seems hard for a couple of reasons.
>
> It sounds like it would have been a good idea 20 years ago when the
> broken i486 platforms were still fairly common, but now we don't even
> know whether the code was intentional or not. I don't remember a lot of
> the specifics of pre-APIC x86, but I do remember IRQ configuration
> as a common problem without a single good solution.

Yes. It still is because even today BIOS tinkerers get it wrong.

> There is a realistic chance that other combinations of broken hardware
> and drivers rely on the x86 PCI code doing exactly what it does today.

Legacy PCI interrupts are specified as being level triggered because
legacy PCI requires to share interrupts and you cannot share edge
triggered interrupts reliably. PCI got a lot of things wrong, but this
part is completely correct.

From experience I know that 8139 depends on that and I debugged that
myself many years ago on an ARM system which had the trigger type
configuration wrong.

Let me clarify why this breaks first. The interesting things to look at
are:

  - the device internal interrupt condition which in this case are
    package received or transmitted and status change

  - the interrupt line

Let's look at the timing diagram of simple RX events:

           ___________________               _____...
RX     ___|                   |_____________|

            ___________________               ____...
INTA   ____|                   |_____________|

              _ INT handler _____ RETI _        __...
Kernel ______|                          |______|

Trivial case which works with both edge and level. Now let me add TX
complete for the level triggered case:

           ___________________              
RX     ___|                   |_____________

                             _______________
TX     _____________________|                   

            ________________________________
INTA   ____|                

              _ INT handle RX ___ RETI_   __ INT handle TX
Kernel ______|                         |_|

Works as expected. Now the same with edge mode on the i8259 side:

           ___________________              
RX     ___|                   |_____________

                             _______________
TX     _____________________|                   

            ________________________________
INTA   ____|                

              _ INT handle RX ___ RETI_   
Kernel ______|                         |_____ <- FAIL


Edge mode loses the TX interrupt when it arrives before the RX condition
is cleared because INTA will not go low.

The driver cannot do anything about it reliably because all of this is
asynchronous. The loop approach is a bandaid and kinda works, but can it
work reliably? No. Aside of that it's curing the symptom which is the
wrong approach.

The only reasonable solution to this is to enforce level even if that
BIOS switch says otherwise.

> If overriding the BIOS setting breaks something that works today, nothing
> is gained, because the next person running into an i486 PCI specific bug
> is unlikely to be as persistent and competent as Nikolai in tracking down
> the root cause.

Yes, sigh. The reason why this BIOS switch exists, which should have
never existed, is that during the transition from EISA which was edge
triggered to PCI some card manufacturers just changed the bus interface
of their cards but completely missed the edge -> level change in
hardware either by stupidity or intentionally so they did not have to
make any changes to the rest of the hardware and to drivers.

The predominant OS'es at that time of course did not have an easy way to
add a quirk to fix this, so the way out was to add the chicken bit
option to the BIOS which then either tells the OS the trigger mode for
INTA..INTD and just sets up ELCR before booting the OS. I have faint
memories that I had to use such a BIOS switch long time ago to get some
add-on PCI card working.

So the right thing to do is to leave 8139 as is and add a PCI quirk
which enforces level trigger type for 8139 in legacy PCI interrupt mode.

Alternatively we can just emit a noisy warning when a legacy PCI
interrupt is configured as edge by the BIOS and tell people to toggle
that switch if stuff does not work. Though that might be futile because
not all BIOSes have these toggle options.

Thanks,

        tglx


