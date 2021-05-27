Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF24E392F16
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhE0NIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:08:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236289AbhE0NHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 09:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622120782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULXKpUDeK1p76UZ59lVMj02cPEcED36GdHXBm75qmHc=;
        b=IWdZ9P7EgT5cE/GYWdZoIg15ogvCE0NlZCM9iCcTt6GVUehjXXbmIkrd3up4k3BQAwFewJ
        MHzKbeJXYcKbbATSOIfMHC/LCyxuXtsM1GfEpKDASnCllmcE++vawcyjtoYGV4dUQwHJi/
        zqmniCDNGX6W4H9kdJ2rFHH2ADQ4Wt0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-vubrZUjHPbmgXGsqkDpikA-1; Thu, 27 May 2021 09:06:19 -0400
X-MC-Unique: vubrZUjHPbmgXGsqkDpikA-1
Received: by mail-lj1-f197.google.com with SMTP id w8-20020a05651c1028b02900f6e4f47184so224965ljm.5
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 06:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULXKpUDeK1p76UZ59lVMj02cPEcED36GdHXBm75qmHc=;
        b=OIOfDQfqR+cJ6qvcni21pWrKHTRU1Ttb6Jh6EMiB/s/GViH3mhW2iMgVON2Yn/ULvd
         d3RZ2gUTKsfN7d5yBOX8CvhfqOxAtuYosQIIsTITeMQuPPo9xaRIugEZySlJ1lMjlnXU
         qp5LBisInrI8fZU5deU4Z05YdruyQSSlP41opnVkHpZ9GmERGnnEFS19LtPGVD59et9w
         tcCJTuCNi/A/l4DwUNNP6f4H/IJNDCzf2DJzv5gsx1vA0rTtSaOoL79AsDgcTclmytab
         d9RdkzmSo2j5lzl71aPY04mmP9x+FZ7dSB+h2BwtAD/btA4ab9oxeGIPg2CZXBAT5AJ6
         Sl1w==
X-Gm-Message-State: AOAM532qtTj2TbCKBcQZlQUOR9B2Gq4vkTLPuo52SdnosUiMXZDStdr+
        61XTXVp8oWQ1gZi0YE2xXqME7zaoQr0LUfMQJcO3ZaLY214Edbm+3ELAGyYeUb4dRWZzCEmRevu
        AvtXoEh3ots7e0LFUYMrUaiDmimasz+TP
X-Received: by 2002:a05:651c:511:: with SMTP id o17mr2571075ljp.14.1622120777521;
        Thu, 27 May 2021 06:06:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZlraGIBVHBafxiPicFv+vN1bDWs7vAmvm5tSF3zLlOVmiHaJA9AlrZjZFdI/T3bbEWL91czd9UgOjRUHHQgQ=
X-Received: by 2002:a05:651c:511:: with SMTP id o17mr2571013ljp.14.1622120777212;
 Thu, 27 May 2021 06:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de> <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
 <YK9ucRrjq+eck/G7@syu-laptop>
In-Reply-To: <YK9ucRrjq+eck/G7@syu-laptop>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Thu, 27 May 2021 09:06:04 -0400
Message-ID: <CAFki+LnuharcwJy=x4Z27ixCMK1u2s2cvHh9=Bcf90rO06osEw@mail.gmail.com>
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
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

On Thu, May 27, 2021 at 6:03 AM Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
>
> Hi,
>
> On Fri, May 21, 2021 at 02:03:06PM +0200, Thomas Gleixner wrote:
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
> >                              the interrupt
> >
> > Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> > document it to be phased out.
>
> Is there recommended way to retrieve the CPU number that the interrupt has
> affinity?
>
> Previously a driver (I'm looking at drivers/net/ethernet/amazon/ena) that
> uses irq_set_affinity_hint() to spread out IRQ knows the corresponding CPU
> number since they're using their own spreading scheme. Now, phasing out
> irq_set_affinity_hint(), and thus relying on request_irq() to spread the
> load instead, there don't seem to be a easy way to get the CPU number.
>

For drivers that don't want to rely on request_irq for spreading and want
to force their own affinity mask can use irq_set_affinity() which is an
exported interface now [1] and clearly indicates the purpose of the usage.

As Thomas suggested we are still keeping irq_set_affinity_hint() as a
wrapper until we make appropriate changes in individual drivers that use
this API for different reasons. Please feel free to send out a patch
for this driver once the changes are merged.

[1] https://lkml.org/lkml/2021/5/18/271

-- 
Thanks
Nitesh

