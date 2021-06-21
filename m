Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062E33AE815
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhFUL1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 07:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhFUL1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 07:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE31061206
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 11:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624274692;
        bh=98DwLI5Cfng9pq33eLde84LcAq7Rl8ROtRthQKA6dPg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GoxVBgD6/3M3++ANsTgS2IhfY9KPHgMJiw9F7gByyBIDzZbIFNDeC697FtQdsFMnQ
         Zdvv6XbL1EJW+v2SzLF/qtaaS7wcLU4pgItNAYiSUNSNDdJvudYXtOG5T7FShy0f/c
         lE9FMOYPqZva0W3GwI3ygbyQn1qYHta64RjfpF8MZBL8Azz5pFEVqOStnD45YvtY2b
         XW/V9Ouuyko2IUpSIuk20gHHp1U21cRR5Uxd2LKqz8Vw/tQb3j3BInq8x3MD8enFQZ
         iRulRGBZurtgfG/CGaUExnUILaf052xspgGNNzk8NviR79jGwjcZDPs0kVJhJ3huoX
         lNsMhBBRWlhWQ==
Received: by mail-wm1-f52.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso9564951wmc.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 04:24:52 -0700 (PDT)
X-Gm-Message-State: AOAM531hKT65NsJoELeZBXtvP8SRWI+M/g/aeov4FI5y9eYSpRKg7jME
        guHYN1WuFxj4hEzhdrGLCTqPiNv/jE/lD5+zE4U=
X-Google-Smtp-Source: ABdhPJzX7N3tjWLLHaO7+nPir/AazdYec2/ADlhwRibb89cqhfvWKQEbk108XXEyg6xtK3HadkUmG8SkAZ/KXZKvRhM=
X-Received: by 2002:a1c:98d5:: with SMTP id a204mr25990040wme.43.1624274691214;
 Mon, 21 Jun 2021 04:24:51 -0700 (PDT)
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
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 21 Jun 2021 13:22:34 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
Message-ID: <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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

On Mon, Jun 21, 2021 at 6:10 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
> On Sun, 20 Jun 2021, Thomas Gleixner wrote:
>
> > Alternatively we can just emit a noisy warning when a legacy PCI
> > interrupt is configured as edge by the BIOS and tell people to toggle
> > that switch if stuff does not work. Though that might be futile because
> > not all BIOSes have these toggle options.
>
>  A warning surely won't hurt, but TBH I'd just reprogram any incorrectly
> configured PCI interrupt line unconditionally where the ELCR is available.
> The chance someone uses a broken PCI card that drives its interrupt line
> as edge-triggered and is actually handled by a Linux driver both at a time
> is IMO nil.  Such a card requires special provisions hardly any system
> provides and has anyone here seen a report of such a beast?

I looked some more through the git history and found at least one time
that the per-chipset ELCR fixup came up for discussion[1], and this
appears to have resulted in generalizing an ALI specific fixup into
common code into common code[2], so we should already be doing
exactly this in many cases. If Nikolai can boot the system with debugging
enabled for arch/x86/pci/irq.c, we should be able to see exactly
which code path is his in his case, and why it doesn't go through
setting that register at the moment.

I also found an slightly more recent discussion, from where it seems
that the authoritative decision when it came up in the past was that edge
triggered interrupts are supposed to work as long as they are not
shared [3][4].

       Arnd

[1] https://lore.kernel.org/lkml/Pine.LNX.4.10.10011230901580.7992-100000@penguin.transmeta.com/
[2] https://repo.or.cz/davej-history.git/commitdiff/e3576079d9e2#patch63
[3] https://yarchive.net/comp/linux/edge_triggered_interrupts.html
[4] https://lore.kernel.org/lkml/Pine.LNX.4.64.0604241156340.3701@g5.osdl.org/
