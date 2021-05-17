Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648D1386D28
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbhEQWqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:46:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241604AbhEQWqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621291484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PzeDuFKqOdq6XOChkUVF1K14DQOzccWrFoItEVYjLtI=;
        b=L61zr0Cbj4Y9P2kE99SUkfC+/y0NdNkYcIj6JnBKPhgTvNuWaZPBdMtBJAZh3lA5uHgTdJ
        xj10Qsut4VP4/2jGDeJZQF8oyYFLDuxJc60oNviAtgy4az5YdtjHvNF1oXDfvJVRE0q70F
        afwEpmafhNA+/gapO1loPirKNCSxNqE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-8zelgdHEMK-0RLc9XeMC-Q-1; Mon, 17 May 2021 18:44:42 -0400
X-MC-Unique: 8zelgdHEMK-0RLc9XeMC-Q-1
Received: by mail-lj1-f197.google.com with SMTP id o5-20020a05651c0505b02900e5a95dd51eso3751411ljp.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PzeDuFKqOdq6XOChkUVF1K14DQOzccWrFoItEVYjLtI=;
        b=hisNGVkgOPFq16DoOjSz7Rmy4bl2HTqGPbUdn21YuzgGVsMSSRgdkPlC2/pXyVkV74
         OqocC4dtzpU0C55Ouo1b/Wg+GZ1w1yBNiCsLVuoc6PdhufFlMMRRSr92r3uHDt6jyCZP
         s5YahjGPWgpPnhcMSVpSaAAimuMKtS1/HXM0z54wh6tIsVjG2t2h4bbz2s8OA/xv6aWB
         uloY+LDkL3Bln6d9l2uUsBfHmzkotp+/rx9qMVDqGwqYVEcfHOMgyNgiPg+SehqFI8X0
         kw+p2Yu3LE1V8Qrso3JADHoWzy6lvUQasT1Y88OizXtlHQvTPCq2NuJ8MguYaU5UN3aA
         j/1g==
X-Gm-Message-State: AOAM5330Mr0YXl8O2oEtDaMI4bXgNsvCRDAhKC2R+dwReNI3aSWYBgw7
        OxKNffYhcXTb9guqOQRUE5blZBIrb5IwdRWYXSWBe69oe9U8Yr0wpt0fx1qp9DKOJIubbhGbsoz
        Ab495eLCZU6VY2oUrIaNdyryCeHVhGFUG
X-Received: by 2002:a05:6512:3da1:: with SMTP id k33mr1581757lfv.114.1621291480841;
        Mon, 17 May 2021 15:44:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybam1+aZWd8ZoxqggTlhbg2Te1/mPCVDQmAynvHsV1tsF6N/JdmZVJTtQ8LuKC3UoE52OmVHe8fTZ2XXqBun0=
X-Received: by 2002:a05:6512:3da1:: with SMTP id k33mr1581740lfv.114.1621291480634;
 Mon, 17 May 2021 15:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87pmxpdr32.ffs@nanos.tec.linutronix.de>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 17 May 2021 18:44:29 -0400
Message-ID: <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
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
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 4:48 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, May 04 2021 at 09:23, Jesse Brandeburg wrote:
> > I'd add in addition that irqbalance daemon *stopped* paying attention
> > to hints quite a while ago, so I'm not quite sure what purpose they
> > serve.
>
> The hint was added so that userspace has a better understanding where it
> should place the interrupt. So if irqbalanced ignores it anyway, then
> what's the point of the hint? IOW, why is it still used drivers?
>

Took a quick look at the irqbalance repo and saw the following commit:

dcc411e7bf    remove affinity_hint infrastructure

The commit message mentions that "PJ is redesiging how affinity hinting
works in the kernel, the future model will just tell us to ignore an IRQ,
and the kernel will handle placement for us.  As such we can remove the
affinity_hint recognition entirely".

This does indicate that apparently, irqbalance moved away from the usage of
affinity_hint. However, the next question is what was this future model?
I don't know but I can surely look into it if that helps or maybe someone
here already knows about it?

> Now there is another aspect to that. What happens if irqbalanced does
> not run at all and a driver relies on the side effect of the hint
> setting the initial affinity. Bah...
>

Right, but if they only rely on this API so that the IRQs are spread across
all the CPUs then that issue is already resolved and these other drivers
should not regress because of changing this behavior. Isn't it?

> While none of the drivers (except the perf muck) actually prevents
> userspace from fiddling with the affinity (via IRQF_NOBALANCING) a
> deeper inspection shows that they actually might rely on the current
> behaviour if irqbalanced is disabled. Of course every driver has its own
> convoluted way to do that and all of those functions are well
> documented. What a mess.
>
> If the hint still serves a purpose then we can provide a variant which
> solely applies the hint and does not fiddle with the actual affinity,
> but if the hint is useless anyway then we have a way better option to
> clean that up.
>

+1



-- 
Thanks
Nitesh

