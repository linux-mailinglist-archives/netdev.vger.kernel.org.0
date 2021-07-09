Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAAD3C200A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhGIHee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhGIHee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622806139A
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 07:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625815911;
        bh=gO6fe7uu30K1aRnJxP7G3No2PQGO/1V5QqwZY5CeLI8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lYUm+j8upcUL50Az08+EBU0dwWZU56oomKlMVyUoaxM97H4AamGMy2RrkkfudXlIE
         cqJ2gLkAvGoZbEO90NOsfbu67/NjDxKqOH069tyq1nAm30PYCSlpMWWf1uho50HScs
         rQjiYB0/AfoYcZXnZk7dGWxaoJNoBZPUSIvVeZF6xiL0bU8IRfoiTKh7/LTFF4q85v
         taW8B2ZI2mgqfq974OwdagK8U5g1zmXzGzhDuYblIiREYvXrBpjyIrczTZRPYPpRfk
         lBaOsQDgaYKq1dQ7Ok83R/zVXHZFQyfA25pUkugVP4jfKhXgH1MjTGc1tb7lvyH/sw
         nQVOmCs7xc4GQ==
Received: by mail-wr1-f43.google.com with SMTP id l7so9880775wrv.7
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 00:31:51 -0700 (PDT)
X-Gm-Message-State: AOAM531N8rkW+pm17OuC/VfAAxyawLduHBWocF+hm/TpSApkGslZW/tM
        KRPP+VZ5hLEyuJiQ7KmfLY8Wnq3UtKjf62VUJgo=
X-Google-Smtp-Source: ABdhPJx+nO3v98cdGJnkOaQvoqTOXfH9nxd97AciSeiPNXpBfrmrt3WRl7pX/ZHJgpMDpo0uCU+jHrC4WYwrKpwfMp4=
X-Received: by 2002:adf:b318:: with SMTP id j24mr15695932wrd.361.1625815909957;
 Fri, 09 Jul 2021 00:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B611C6.2000801@gmail.com>
 <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com>
 <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
 <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
 <60D361FF.70905@gmail.com> <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
 <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
 <60DF62DA.6030508@gmail.com> <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
 <60E75057.60706@gmail.com>
In-Reply-To: <60E75057.60706@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 9 Jul 2021 09:31:34 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0uFAsKXenAhPdJWXVNUNw1qjuyrY+5jaEtB25Tj8wK3w@mail.gmail.com>
Message-ID: <CAK8P3a0uFAsKXenAhPdJWXVNUNw1qjuyrY+5jaEtB25Tj8wK3w@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 9:21 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> Hello Arnd,
>
> 03.07.2021 12:10, Arnd Bergmann:
> > The simplest workaround would be to just move the
> > "spin_lock_irqsave(&tp->lock, flags);" a few lines down, below the rx
> > processing. This keeps the locking rules exactly how they were before
>
> Indeed, moving spin_lock_irqsave below rtl8139_rx eliminated the warn_on
> message apparently, here is a new log:
>
> https://pastebin.com/dVFNVEu4
>
> and here is my resulting diff:
>
> https://pastebin.com/CzNzsUPu

Ok, great, the patch looks good to me, and I think we should just
merge that, in addition to Maciej's bugfix for the platform.

> My usual tests run fine. However I still see 2 issues:
>
> 1. I do not understand all this locking thing enough to do a good
> cleanup myself, and it looks like it needs one;

A lot of drivers need one. With your latest patch, I'm confident enough
that it's not getting worse here and given the age of this device I don't
think the cleanup is required. It's probably possible to squeeze out a
little more performance from this device on SMP systems by
improving it, but this would still be hopeless to compete against a
$5 gigabit ethernet card.

> 2. It looks like in case of incorrect (edge) triggering mode, the "poll
> approach" with no loop added in the poll function would still allow a
> race window, as explained in following outline (from some previous mails):
>
> 22.06.2021 14:12, David Laight:
>  > Typically you need to:
>  > 1) stop the chip driving IRQ low.
>  > 2) process all the completed RX and TX entries.
>  > 3) clear the chip's interrupt pending bits (often write to clear).
>  > 4) check for completed RX/TX entries, back to 2 if found.
>  > 5) enable driving IRQ.
>  >
>  > The loop (4) is needed because of the timing window between
>  > (2) and (3).
>  > You can swap (2) and (3) over - but then you get an additional
>  > interrupt if packets arrive during processing - which is common.
>
> So in terms of such outline, the "poll approach" now implements 1, 2, 3,
> 5 but still misses 4, and my understanding is that it is therefore still
> not a complete solution for the broken triggering case (Although
> practically, the time window might be too small for the race effect to
> be ever observable) From my previous testing I know that such a loop
> does not affect the perfomance too much anyway, so it seems quite safe
> to add it. Maybe I've missunderstood something though.

The latest version of your patch already does what David explained as
the alternative: the 'ack'  (step 3) happens before processing the interrupts
(2), so you don't need step 4 for correctness. You had that in the previous
version of the patch that had the loop, and since you have experimentally
shown that it makes no significant difference to performance, I'd rather
leave it out for simplicity.

If another event becomes pending after the Ack but before the
napi_complete_done(), then we get an interrupt and call napi_schedule()
again.

For some reason, the TxErr bit is only cleared after tx processing, so
we could miss an error event, but that seems fine as the tx errors are
not handled in any way other than counting them, which is already
unreliable if multiple transmits fail before the interrupt comes.

       Arnd
