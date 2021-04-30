Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03836FE50
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhD3QPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:15:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230081AbhD3QPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 12:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619799265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=alwAQ5VEHKiy/Rben4QlM5DZwditekPwnzgprKEw46c=;
        b=JcbIJNakHilCme1v7iumNMyszlaKjJcQE9Y4B5R55a0KKjwdiMR7kyZ6/i94uDFAySBamU
        1VB4G+MgwcXT8La9HjZ/1kpyXy6A4W0AFUh/ZCMljJSaMAuhrGA8jVfDU00PKp0p2TrAt6
        nn3sRE49mqgV+wyWpYhNbgidkIwFq/0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-a9bheTJUMiKa3dRNKOr6bA-1; Fri, 30 Apr 2021 12:14:22 -0400
X-MC-Unique: a9bheTJUMiKa3dRNKOr6bA-1
Received: by mail-lj1-f197.google.com with SMTP id e15-20020a05651c038fb02900ba7bf7d589so19471249ljp.20
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 09:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=alwAQ5VEHKiy/Rben4QlM5DZwditekPwnzgprKEw46c=;
        b=iNfSUR/TJ3jTqz0JPnIxceUjOKsB+/Vz7a8xNY553vYUwnpiSIE7N8qni4vMBN4Kjo
         TN0JFTLbzFPncm5mLnEnwosQyaGBKGFBOTI7Q5iuvSDAux5KOZOm4tpi4gfYL2ym3LDZ
         ihgfW6rhz1iDv9Lxxi5TwZH7pHo8jeMY9rvu/LYXzevrgcS3ZmJzkyeg6WUjRYYwn9/b
         4PUTxFORWmEwZ7UbDLWlrCSdkR2NffCRBaJ9/poE9VnFQcu7ct3EwDRcSpXs5oT9/tYn
         OPwj8UBimn5nGoMvCoKn6bW4XebKQEcpjOxEnaTvUcTsYZHvP3rVhDVF3V86Obcs8Xpb
         EPwg==
X-Gm-Message-State: AOAM5335ClPuJlZu8VtUGi7TB5qg7hlhvJnUN5P4zy6KlqQ2Obvu7uPM
        b2bKHsRgT/KMrJ+jCeshm6ktykzuDWEM9EayKJJ7lABBgmzZkFhWwG7oRaPhvsMCyiU+KsTZ2N0
        gHYom4xCJ8qK70CWHbBBPwyBraIO8n1ta
X-Received: by 2002:a2e:b4c3:: with SMTP id r3mr4318861ljm.232.1619799260364;
        Fri, 30 Apr 2021 09:14:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/mmdtzRFZu/aZahuTKRW/J7mGPP8sSHBf5+LHrqbtkwseYi05zDtSfrnd1l2wPm6VEtdHMg5ZjaII1U23xI8=
X-Received: by 2002:a2e:b4c3:: with SMTP id r3mr4318844ljm.232.1619799260159;
 Fri, 30 Apr 2021 09:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200625223443.2684-1-nitesh@redhat.com> <20200625223443.2684-2-nitesh@redhat.com>
 <3e9ce666-c9cd-391b-52b6-3471fe2be2e6@arm.com> <20210127121939.GA54725@fuller.cnet>
 <87r1m5can2.fsf@nanos.tec.linutronix.de> <20210128165903.GB38339@fuller.cnet>
 <87h7n0de5a.fsf@nanos.tec.linutronix.de> <20210204181546.GA30113@fuller.cnet>
 <cfa138e9-38e3-e566-8903-1d64024c917b@redhat.com> <20210204190647.GA32868@fuller.cnet>
 <d8884413-84b4-b204-85c5-810342807d21@redhat.com> <87y2g26tnt.fsf@nanos.tec.linutronix.de>
 <d0aed683-87ae-91a2-d093-de3f5d8a8251@redhat.com> <7780ae60-efbd-2902-caaa-0249a1f277d9@redhat.com>
 <07c04bc7-27f0-9c07-9f9e-2d1a450714ef@redhat.com> <20210406102207.0000485c@intel.com>
 <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com> <20210414091100.000033cf@intel.com>
 <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com> <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
 <87czucfdtf.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87czucfdtf.ffs@nanos.tec.linutronix.de>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Fri, 30 Apr 2021 12:14:08 -0400
Message-ID: <CAFki+LmmRyvOkWoNNLk5JCwtaTnabyaRUKxnS+wyAk_kj8wzyw@mail.gmail.com>
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to houskeeping CPUs
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 3:10 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Nitesh,
>
> On Thu, Apr 29 2021 at 17:44, Nitesh Lal wrote:
>
> First of all: Nice analysis, well done!

Thanks, Thomas.

>
> > So to understand further what the problem was with the older kernel based
> > on Jesse's description and whether it is still there I did some more
> > digging. Following are some of the findings (kindly correct me if
> > there is a gap in my understanding):

<snip>

> >
> > I think this explains why even if we have multiple CPUs in the SMP affinity
> > mask the interrupts may only land on CPU0.
>
> There are two issues in the pre rework vector management:
>
>   1) The allocation logic itself which preferred lower numbered CPUs and
>      did not try to spread out the vectors accross CPUs. This was pretty
>      much true for any APIC addressing mode.
>
>   2) The multi CPU affinity support if supported by the APIC
>      mode. That's restricted to logical APIC addressing mode. That is
>      available for non X2APIC up to 8 CPUs and with X2APIC it requires
>      to be in cluster mode.
>
>      All other addressing modes had a single CPU target selected under
>      the hood which due to #1 was ending up on CPU0 most of the time at
>      least up to the point where it still had vectors available.
>
>      Also logical addressing mode with multiple target CPUs was subject
>      to #1 and due to the delivery logic the lowest numbered CPU (APIC)
>      was where most interrupts ended up.
>

Right, thank you for confirming.


Based on this analysis and the fact that with your re-work the interrupts
seems to be naturally spread across the CPUs, will it be safe to revert
Jesse's patch

e2e64a932 genirq: Set initial affinity in irq_set_affinity_hint()

as it overwrites the previously set IRQ affinity mask for some of the
devices?

IMHO if we think that this patch is still solving some issue other than
what Jesse has mentioned then perhaps we should reproduce that and fix it
directly from the request_irq code path.

-- 
Nitesh

