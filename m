Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F237B3E5E16
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbhHJOfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240466AbhHJOfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628606127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuleXyR+sNlj9g2DShREE6mi7Rwvdwecde57TVTjsGo=;
        b=Ff5aiW7f/Qrk1RvitA260Ltt52EZzlFTmRGlg9hu5vczu3V3X4sAfxJHQw/zVmPkxRye7g
        VAOiFBXd6k5skf7VtLOYdYXaw/nSP4bN/uF2iHWCTOVw5pKF9+epw5kGe3iRL25WpPb1GX
        pVp2mGcLtnMczzwz/xlIsTYhmwztXxs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-BPAYrd-zM5ymmydnTaYcuw-1; Tue, 10 Aug 2021 10:35:26 -0400
X-MC-Unique: BPAYrd-zM5ymmydnTaYcuw-1
Received: by mail-lf1-f70.google.com with SMTP id c22-20020a0565122396b02903baf09a3b2aso7634345lfv.14
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 07:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QuleXyR+sNlj9g2DShREE6mi7Rwvdwecde57TVTjsGo=;
        b=OQz1Llc8NpipqVER10uKwijoSUmh+v4Ql6weqa2CKRfYoDHpODDuouBnggXpMud7wc
         56Rle9etH5Jabr2jg1DgoGx4wVdFPwiWZqAkPqSmDQADgzWaSnC2dk4e7mWTXe32oAvp
         QE5xpsnAplCllIUm0RFVuH+2iODsjNlIMgONUB40TMfe5qSu/wA0zccEziXz8AeoxpU7
         z5uC8NWug/A6p+Je1RYI3lnn2ZsyDboYD4+sdJ09flV5IOdE+ZZqpsaAnQznyjwRBiDN
         KYqvORsB1lMRqr16FKUMc7ZeV5XVumn/xhixfVsaAJmRaZghr6H7x8fenG2FWLEGpdEN
         gimw==
X-Gm-Message-State: AOAM531AKlHuewDELlqtLoQXJ0zFPDbvyH1sb99iTQaemVzEfcR87Jae
        XhWA8N4tWaW0osjnEajdVFY195Z0u69vG5LGYOIp1nLw7LWYWXULcUa6DjIU1pbsxyg3BL0Nf97
        t25yx5peRG0kLfccrXtcmbnQQwLRnaYCx
X-Received: by 2002:ac2:4a8d:: with SMTP id l13mr22302483lfp.159.1628606125007;
        Tue, 10 Aug 2021 07:35:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoIK6TD5A73rHnQ3By+bHVTK4cm690K8FNj2ppWk8aIHf21ATwuNIwUvmEjJMo0DOrYajSveCWTS9mlG393l4=
X-Received: by 2002:ac2:4a8d:: with SMTP id l13mr22302468lfp.159.1628606124828;
 Tue, 10 Aug 2021 07:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <YL3LrgAzMNI2hp5i@syu-laptop> <874kbxs80q.ffs@tglx>
In-Reply-To: <874kbxs80q.ffs@tglx>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Tue, 10 Aug 2021 10:35:13 -0400
Message-ID: <CAFki+Lmve_AqiTY-Y_6Rv1aqegbVph2hOcODdE9JS5S2m=jpaw@mail.gmail.com>
Subject: Re: [RFC] genirq: Add effective CPU index retrieving interface
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 10:13 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, Jun 07 2021 at 15:33, Shung-Hsi Yu wrote:
> > Most driver's IRQ spreading scheme is naive compared to the IRQ spreading
> > scheme introduced since IRQ subsystem rework, so it better to rely
> > request_irq() to spread IRQ out.
> >
> > However, drivers that care about performance enough also tends to try
> > allocating memory on the same NUMA node on which the IRQ handler will run.
> > For such driver to rely on request_irq() for IRQ spreading, we also need to
> > provide an interface to retrieve the CPU index after calling
> > request_irq().
>
> So if you are interested in the resulting NUMA node, then why exposing a
> random CPU out of the affinity mask instead of exposing a function to
> retrieve the NUMA node?

Agreed, probably it will make more sense for the drivers to pass either the
local NUMA node index or NULL (in case they don't care about it) as a
parameter then at the time of allocation, we only find the best-fit CPUs
from that NUMA?

or, maybe we should do this by default, and if the local NUMA CPUs run out
of available vectors then we go to the other NUMA node CPUs.

>
> > +/**
> > + * irq_get_effective_cpu - Retrieve the effective CPU index
> > + * @irq:     Target interrupt to retrieve effective CPU index
> > + *
> > + * When the effective affinity cpumask has multiple CPU toggled, it just
> > + * returns the first CPU in the cpumask.
> > + */
> > +int irq_get_effective_cpu(unsigned int irq)
> > +{
> > +     struct irq_data *data = irq_get_irq_data(irq);
>
> This can be NULL.
>
> > +     struct cpumask *m;
> > +
> > +     m = irq_data_get_effective_affinity_mask(data);
> > +     return cpumask_first(m);
> > +}
>
> Thanks,
>
>         tglx
>


-- 
Thanks
Nitesh

