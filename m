Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B9B398509
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 11:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhFBJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 05:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhFBJQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 05:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9339610A8
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622625267;
        bh=D2XDbsraEu5eKDNaqQNc9E3nvWjMEopCd1dKvbVIrE4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nvPS8sL0sHKKgUlItNi1g1XOby6qmRbjkP0xCbJu0GPt+LM/FzabgJCO4EErwccSx
         AqQY7ytakdmoqnQHYTVhpZpItVm1bgkbRJjI0keJphHnjHUW+vXxj1c7znZU5SoFRt
         2ABVjAZyxGqzOgXhvzF6adNukosJA6cBa1aFgF+5ymj9xmXe4N2IQ1BEGxBAvtJ1ka
         PmItSSt1+w1ymRAk+gOXoBjLCB63OdKneVXk2q9z4JWQCCxsKI4pezVMJZuOaLs9n6
         E79/x6s24r8IHQcorJrrEutEFZ3QgbalqR9flR7EvY8vTFoIpn+3gKeACucKblL3Zw
         YlvyaYV4QOMLw==
Received: by mail-wm1-f47.google.com with SMTP id f17so787170wmf.2
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 02:14:27 -0700 (PDT)
X-Gm-Message-State: AOAM530Y207Uz1staCa1N/59aoWKW2K+uZNkCloNOxD19UCF+VXq66EC
        FwuejG7KTDhrFiiUE6o4M4/Y6PfVi6F3ad/hWvI=
X-Google-Smtp-Source: ABdhPJz3RnTna8SnDhQ/zvdzBsh2B4cLfUw4bMGNLxKIDdhtQy+BXnlQRU1rQIzhjoFCaHCjM7W6hU7vbMoTwnfUhpM=
X-Received: by 2002:a1c:7210:: with SMTP id n16mr3988524wmc.75.1622625266471;
 Wed, 02 Jun 2021 02:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com>
In-Reply-To: <60B6C4B2.1080704@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 2 Jun 2021 11:12:47 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
Message-ID: <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 1:27 AM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> 02.06.2021 0:48, Heiner Kallweit:
> > Driver 8139too has no maintainer.
>
> Ups, indeed. I just looked at the header and supposed it has. Sorry.
> (I do not touch kernel development much, usually)

It was apparently maintained by Jeff Garzik until 2007, but he already
considered
this driver outdated back then, and later stopped maintaining drivers
altogether.

> > who are paid by somebody to maintain all drivers in the kernel. That's not the case in general.
> > You provided valuable input, and if you'd contribute to improving 8139too and submit patches for
> > fixing the issue you're facing, this would be much appreciated.
>
> Ok, it is a bit more clear now.
> I'll do more testing/searching/reading and probably come up with
> something then.

I thought about the issue a bit more. The idea of the level interrupt
handler is that it
gets called again as long as any of the bits in 'IntrStatus' are set,
so the handler
can just read the register, write ack or mask the bits it sees and then process
the events it got. If another tx-complete even comes in before the end
of the handler,
it gets entered again and everything works.

If the irqchip is set to edge mode, this breaks down, and the loop can
work around
it by making it much more likely that all bits are cleared or masked at the
end of the handler, but there is no guarantee for this: If any
interrupt comes in
between reading the IntrStatus register and finishing the handler, you never get
an interrupt again.

I think the easiest workaround to address this reliably would be to move all
the irq processing into the poll function. This way the interrupt is completely
masked in the device until the poll handler finishes, and unmasking it
while there
are pending events would reliably trigger a new irq regardless of level or edge
mode. Something like the untested change at https://pastebin.com/MhBJDt6Z .
I don't know of other drivers that do it like this though, so I'm not
sure if this
causes a different set of problems.

       Arnd
