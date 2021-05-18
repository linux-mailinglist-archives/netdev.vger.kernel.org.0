Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF470386E46
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbhERAYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238828AbhERAYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621297400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1CFhwAdeADWfjY+TeEUXI0dttR2qRWxmhTMkaKMBCuk=;
        b=UYZaEetOebS9zOWu1FUz6LGrN+u/Tw0wjudDwjeHlvrZRWwTYwZG/+maG0ai0yZfc0dB5l
        DBkmUdaC2lHxEdaPMSiMfXC+/QTb6KpVyPwsU88j8m2v4Qp1u5yqL1JEhXYRsBaQzmKWrS
        zYPduMi7BE4J9WnNFqHsdM2efYd3Wms=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-SPpMYPMTN_es3zOJ7DnspA-1; Mon, 17 May 2021 20:23:18 -0400
X-MC-Unique: SPpMYPMTN_es3zOJ7DnspA-1
Received: by mail-lj1-f197.google.com with SMTP id v26-20020a2e481a0000b02900bf48f13296so3866247lja.1
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 17:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1CFhwAdeADWfjY+TeEUXI0dttR2qRWxmhTMkaKMBCuk=;
        b=Lsr/n2NHH+t9vPeQU5bytD1TYP21pfK997LUwnNfpcywlfIbyBy1TtMXn475F0NAWG
         TQw5f2boNd+9OwN10oHmLIJ03HZ0yL9reQuK6br7VIrldqn+Wje5qvCf4/oT/Lgm5USe
         dOi+rjSCzUJwStzcalNjgWunDq/S+zEtttb1h4VsYdglIGRQO/KHjXTOE1xsAeJfwHT+
         ibh4OkSwWCMdVI0x97U4T7REUQi6U8238KkuY6InRaCcA0iyLpMq4MvShZ77du1MZTm5
         mJTZc+JxZnvQFYi8P72lA6DSr6tGIAT5UYVqYAUmf1Cg1oPj4DIVwAXJ3fqi5mYSlNRe
         bVog==
X-Gm-Message-State: AOAM533sGw154G5rEe5tMIZkQ6o7amRs/zqCBonxxAuXgc2BfLRHJKa9
        rb8IkFwvg1hOu9Lup7JfMuoD7w8VYG3kjjwiLT/oqsYGaq+JajiIEkfjAGGLa/8Ok+d18BLshgs
        m1tz5b2LtMo/Sh6oUI57+83COTXQrD23X
X-Received: by 2002:a05:6512:3da1:: with SMTP id k33mr1954913lfv.114.1621297396823;
        Mon, 17 May 2021 17:23:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhOM/aeHK0aO1U0IXX7Bz97GQL+BiXI9gjCeNpT1VQx45C+gwAHC4wQS/KVuaPU2Um6MqyAaMyIDDi2YeTCBA=
X-Received: by 2002:a05:6512:3da1:: with SMTP id k33mr1954902lfv.114.1621297396624;
 Mon, 17 May 2021 17:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87im3gewlu.ffs@nanos.tec.linutronix.de>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 17 May 2021 20:23:05 -0400
Message-ID: <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when
 setting the hint
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
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

On Mon, May 17, 2021 at 8:04 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, May 17 2021 at 18:44, Nitesh Lal wrote:
> > On Mon, May 17, 2021 at 4:48 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> The hint was added so that userspace has a better understanding where it
> >> should place the interrupt. So if irqbalanced ignores it anyway, then
> >> what's the point of the hint? IOW, why is it still used drivers?
> >>
> > Took a quick look at the irqbalance repo and saw the following commit:
> >
> > dcc411e7bf    remove affinity_hint infrastructure
> >
> > The commit message mentions that "PJ is redesiging how affinity hinting
> > works in the kernel, the future model will just tell us to ignore an IRQ,
> > and the kernel will handle placement for us.  As such we can remove the
> > affinity_hint recognition entirely".
>
> No idea who PJ is. I really love useful commit messages. Maybe Neil can
> shed some light on that.
>
> > This does indicate that apparently, irqbalance moved away from the usage of
> > affinity_hint. However, the next question is what was this future
> > model?
>
> I might have missed something in the last 5 years, but that's the first
> time I hear about someone trying to cleanup that thing.
>
> > I don't know but I can surely look into it if that helps or maybe someone
> > here already knows about it?
>
> I CC'ed Neil :)

Thanks, I have added PJ Waskiewicz as well who I think was referred in
that commit message as PJ.

>
> >> Now there is another aspect to that. What happens if irqbalanced does
> >> not run at all and a driver relies on the side effect of the hint
> >> setting the initial affinity. Bah...
> >>
> >
> > Right, but if they only rely on this API so that the IRQs are spread across
> > all the CPUs then that issue is already resolved and these other drivers
> > should not regress because of changing this behavior. Isn't it?
>
> Is that true for all architectures?

Unfortunately, I don't know and that's probably why we have to be careful.

--
Nitesh

