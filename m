Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537B13A6B5E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhFNQO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234511AbhFNQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623687173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U/Ya1k1nXvvGjrRExG8q3FmOawUUZX1h7T0TrtPnmSM=;
        b=goCD3QgnotXIocEKYMZfH5VHj3SH8r1CrIdjRuQFOmtK6s+T5uQqMNdX+tp8hgxvd59hUz
        Zw6bfEueQUOIzXiqINcQEnru9p01MTzM8XGKRMqFz0ADajzLjaxBcAW7mEhF2pvRVOYqTY
        qwnMqK75yMAG7Qw98a7xk8IyGizTIW8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-mQ46DbCIPcKVV77sVzEfYQ-1; Mon, 14 Jun 2021 12:12:52 -0400
X-MC-Unique: mQ46DbCIPcKVV77sVzEfYQ-1
Received: by mail-lj1-f200.google.com with SMTP id j2-20020a2e6e020000b02900f2f75a122aso4935630ljc.19
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 09:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/Ya1k1nXvvGjrRExG8q3FmOawUUZX1h7T0TrtPnmSM=;
        b=hnR7klmn4xukWXTYzGrNFGTOBYm/lsgAkAejrrhit+3zznqpa/13j+o1E4+ovc9VW1
         dH8RwnFdAe4fDuJHtE3Q272nOEURtl5qwAN5ThD+r6u7hHp8rYARFzqewSfbdEYd1dHT
         1Sxhuo7cYRwyTF8OkbzJ1GAAEBDrN7SEpQMSsrxvp2QR299HR++L/XAvDt9XQ1qvY8gN
         ulITQ0MpwTiKrSmwweEoZUfCOFewRFyKyyqsU9ECs96Ng4Yq+JhROtm1fYftvahhactf
         SJbP5l0n1QLRhSgB8XYFu5tyOW0Qxt5S0QGO/DcDaMaGLlNdJd/lD6kk2amHryUtL3D5
         379A==
X-Gm-Message-State: AOAM533W1J4e77VYNn3wcDIpv4zQdFxEV2Ug9IL5h8hsqBsDjmvPrlR0
        KyN1bM69VgBy5t5/D0f2XjxJO0ZfZDeX+UUwKZP6d/Zzw7rkGvpkEZ0F4MdAAfsuCGHx3Rm5RSa
        QQrNjFawoQzrLEY1xznl6vgn1GtELcCSi
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr8877548lfr.647.1623687170827;
        Mon, 14 Jun 2021 09:12:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAbGhpPvqkcHhSsuAdQ1FpWwNWtaQWb83YFBtFmuq7Xr7R/t1YH4+Rj9W+tz1cElNmEXnhxmp8Ko9KgVy5pjU=
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr8877529lfr.647.1623687170605;
 Mon, 14 Jun 2021 09:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de> <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
 <CAFki+L=QTOu_O=1uNobVMi2s9mbcxXgSdTLADCpeBWBoPAikgQ@mail.gmail.com>
In-Reply-To: <CAFki+L=QTOu_O=1uNobVMi2s9mbcxXgSdTLADCpeBWBoPAikgQ@mail.gmail.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 14 Jun 2021 12:12:38 -0400
Message-ID: <CAFki+LkJ9kj0TMz8dhGXLXdfwgYLibkMCRvKBwVVX5+F-DP37w@mail.gmail.com>
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 1:00 PM Nitesh Lal <nilal@redhat.com> wrote:
>
> On Fri, May 21, 2021 at 8:03 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > The discussion about removing the side effect of irq_set_affinity_hint() of
> > actually applying the cpumask (if not NULL) as affinity to the interrupt,
> > unearthed a few unpleasantries:
> >
> >   1) The modular perf drivers rely on the current behaviour for the very
> >      wrong reasons.
> >
> >   2) While none of the other drivers prevents user space from changing
> >      the affinity, a cursorily inspection shows that there are at least
> >      expectations in some drivers.
> >
> > #1 needs to be cleaned up anyway, so that's not a problem
> >
> > #2 might result in subtle regressions especially when irqbalanced (which
> >    nowadays ignores the affinity hint) is disabled.
> >
> > Provide new interfaces:
> >
> >   irq_update_affinity_hint() - Only sets the affinity hint pointer
> >   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
> >                                the interrupt
> >
> > Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> > document it to be phased out.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
> > ---
> > Applies on:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
> > ---
> >  include/linux/interrupt.h |   41 ++++++++++++++++++++++++++++++++++++++++-
> >  kernel/irq/manage.c       |    8 ++++----
> >  2 files changed, 44 insertions(+), 5 deletions(-)
> >
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -328,7 +328,46 @@ extern int irq_force_affinity(unsigned i
> >  extern int irq_can_set_affinity(unsigned int irq);
> >  extern int irq_select_affinity(unsigned int irq);
> >
> > -extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
> > +extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> > +                                    bool setaffinity);
> > +
> > +/**
> > + * irq_update_affinity_hint - Update the affinity hint
> > + * @irq:       Interrupt to update
> > + * @cpumask:   cpumask pointer (NULL to clear the hint)
> > + *
> > + * Updates the affinity hint, but does not change the affinity of the interrupt.
> > + */
> > +static inline int
> > +irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +       return __irq_apply_affinity_hint(irq, m, true);
> > +}
> > +
> > +/**
> > + * irq_apply_affinity_hint - Update the affinity hint and apply the provided
> > + *                          cpumask to the interrupt
> > + * @irq:       Interrupt to update
> > + * @cpumask:   cpumask pointer (NULL to clear the hint)
> > + *
> > + * Updates the affinity hint and if @cpumask is not NULL it applies it as
> > + * the affinity of that interrupt.
> > + */
> > +static inline int
> > +irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +       return __irq_apply_affinity_hint(irq, m, true);
> > +}
> > +
> > +/*
> > + * Deprecated. Use irq_update_affinity_hint() or irq_apply_affinity_hint()
> > + * instead.
> > + */
> > +static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +       return irq_apply_affinity_hint(irq, cpumask);
>
> Another change required here, the above should be 'm' instead of 'cpumask'.

I am going to and make the suggested changes to this patch and will post it
with driver patches.
Please let me know if there are any objections to that.

>
> > +}
> > +
> >  extern int irq_update_affinity_desc(unsigned int irq,
> >                                     struct irq_affinity_desc *affinity);
> >
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -487,7 +487,8 @@ int irq_force_affinity(unsigned int irq,
> >  }
> >  EXPORT_SYMBOL_GPL(irq_force_affinity);
> >
> > -int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> > +                             bool setaffinity)
> >  {
> >         unsigned long flags;
> >         struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
> > @@ -496,12 +497,11 @@ int irq_set_affinity_hint(unsigned int i
> >                 return -EINVAL;
> >         desc->affinity_hint = m;
> >         irq_put_desc_unlock(desc, flags);
> > -       /* set the initial affinity to prevent every interrupt being on CPU0 */
> > -       if (m)
> > +       if (m && setaffinity)
> >                 __irq_set_affinity(irq, m, false);
> >         return 0;
> >  }
> > -EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
> > +EXPORT_SYMBOL_GPL(__irq_apply_affinity_hint);
> >
> >  static void irq_affinity_notify(struct work_struct *work)
> >  {
> >
>
>
> --
> Thanks
> Nitesh



-- 
Thanks
Nitesh

