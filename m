Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68D93AEC37
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFUPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhFUPZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 11:25:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734AF61156
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624288998;
        bh=gNra/Ej0I36Z6E74Xnlm3clEIoHXIvp7+bs2+vb9THQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FAGcJIVBz1mnnkI4ocaYDxirI97rkrcOqnrtlosQUslBdRK8Z98R2+qOoCpL/Wga+
         g6Gmjd/Tv/jIYSSTOb59NujP9vGVmbBlqVTalbw7U1Y9KjoD/y5P2srTN8G8Eba4nY
         K96KH5jMH9s/34Kbie8UH7Y1wLffP35Tbl8hRDYRT0qRXBQJuDjltMLKmSpNRgzlbK
         WmEMbaiJIVI0QNFdcueYciJ8cIzmW30fQD78ExppxzMJuMfmzSJ7+fNxFhH9WrswOw
         7a205UUwqDeZJyRhfMxchfqgjZoTwaQeFWT0Mb+o6LQ0tbQiBowXTBXSTSSb879Zle
         Y7CmpItBC4k6g==
Received: by mail-wr1-f52.google.com with SMTP id j2so9588880wrs.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 08:23:18 -0700 (PDT)
X-Gm-Message-State: AOAM533h73gq8y04Qr4PdwRuQ/5aTOUMvPDkwd9A3r0j7CLdEJ8hNIhX
        cJZw0uV1yHUVwVrrwJPFSNU0KdZ9lAwsApR7UfA=
X-Google-Smtp-Source: ABdhPJxf8ZM5gM6lm4UWwfoj4dKdSh8BZZSyWdhxabY73npVuYOcffQnxg000SQDEBB4qnL0k7wjnVsLfJXNiNiyxgg=
X-Received: by 2002:a5d:5905:: with SMTP id v5mr4053551wrd.361.1624288996976;
 Mon, 21 Jun 2021 08:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B2E0FF.4030705@gmail.com>
 <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <alpine.DEB.2.21.2106211623090.779@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106211623090.779@angie.orcam.me.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 21 Jun 2021 17:20:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a30Pz+_Mud-VYsMw9XEsE5KBUHyMF4KzUr9XYiXi9D91g@mail.gmail.com>
Message-ID: <CAK8P3a30Pz+_Mud-VYsMw9XEsE5KBUHyMF4KzUr9XYiXi9D91g@mail.gmail.com>
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

On Mon, Jun 21, 2021 at 4:42 PM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Mon, 21 Jun 2021, Arnd Bergmann wrote:
>
> > I also found an slightly more recent discussion, from where it seems
> > that the authoritative decision when it came up in the past was that edge
> > triggered interrupts are supposed to work as long as they are not
> > shared [3][4].
>
>  Sadly Linus's rule applies both ways: if a device has been designed with
> level-triggered interrupts in mind, there may be no race-free way to
> ensure an active-to-inactive-to-active transition has happened on its IRQ
> line as the driver acknowledges handling in the relevant device's CSR.
>
>  The rule of thumb is to acknowledge early in the handler, and to work
> around broken configurations it may be desirable to also briefly mask all
> the interrupt sources with the device so as to make sure it deasserts its
> IRQ line even if another interrupt has already been queued.  OTOH if IRQ
> sharing is to be supported a device absolutely has to have an interrupt
> mask register, as the system cannot rely on masking at the interrupt
> controller if multiple devices are to be handled with a single line.  I
> suspect many of our drivers do not do such precautionary masking though.
>
>  Is there a mask register with the 8139?

Ah, it seems that the Cc list got dropped in a different sub-thread, see
https://pastebin.com/3FUUrg7C for a version of my patch that Nikolai
tested successfully. This one goes further by completely masking
all interrupts between the hardirq handler and the subsequent
napi_complete_done(). This may not be the most efficient way of
doing it, but it seems good enough according to his measurements,
and it is a relatively safe and straightforward change.

      Arnd
