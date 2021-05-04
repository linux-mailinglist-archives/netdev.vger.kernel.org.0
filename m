Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8B372C07
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 16:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhEDOaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 10:30:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230463AbhEDOaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 10:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620138564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/C/wTNOTCb+yGfszfpaIVYIq+8oCD0tOIWtXOH684UQ=;
        b=OyYxFR1j4KehwpRmCFywOBvwaMw7Wjd+nQjQMIkoj9XLuyv8ZWbNmAJJgLM3MiaLrIfNGE
        kqciXjRUoEWLoKb+m9Pe2/74WvEVCg1V49XSXt/Jhx+drdOTe7EYCwKHM0pBwDmdAGsrMy
        h8pzs4ltdFGoaXhUGRbCXmM0cv1Qkag=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-O_3XoLbWMR-V6-nJ1cLLMw-1; Tue, 04 May 2021 10:29:22 -0400
X-MC-Unique: O_3XoLbWMR-V6-nJ1cLLMw-1
Received: by mail-ej1-f70.google.com with SMTP id z15-20020a170906074fb029038ca4d43d48so3194525ejb.17
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 07:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/C/wTNOTCb+yGfszfpaIVYIq+8oCD0tOIWtXOH684UQ=;
        b=ZKSWBHSD9U0SzTthcb5ayhdJFFoKCWmE3EV+FX8yVvGwS8fQnofHDE2SJp+UGS1VJl
         +hfPqZ+UuOWtwLEFOGO+DZHaGn3TtBi1EaxdlD0MrESI5txA9nHcwVFF00yY+ON0/xkw
         XJrmTzlnmlZUTn4wlDof1EWsTHICFtnRQRPWy+jn18SU9Use4HSzPBjZ1yrXdV32gBiS
         I/bbWvC2F64G9a8G4V7O0bUEdCjuBcjKWsprwQobv+H+ZZQbdkquKmIJBUKSYyQVocIF
         b8RmOnNxUfgODFQovDzP+6SX6b9kLkTNI9FlmeHRjGJXOkQDFGuWTETABWJCC4CKNEaj
         /Kdg==
X-Gm-Message-State: AOAM533mIm659K4Iey94XDS0R2oZkTp6ovbFn4nvYg53aYfsMajr8cps
        FIHRuNeHPRc0qsISydNvEfJjcdx4uZalQ2j2IQYO90WDvljxw1rLooDXPVXhUW1acQ9mjUGLMa4
        puJrCwVzqoK2DUvXwJeuawtgK4vd/W7aL
X-Received: by 2002:a17:906:9a02:: with SMTP id ai2mr22704485ejc.279.1620138561161;
        Tue, 04 May 2021 07:29:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBQGqUZtw6piWjtshZQhonbqeKOMWr75L9XDey1rFpJCXv1AQK+Jw5/m9KuadTFtTp9gtXISJlA+uPKf1wTjE=
X-Received: by 2002:a17:906:9a02:: with SMTP id ai2mr22704467ejc.279.1620138560926;
 Tue, 04 May 2021 07:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210501021832.743094-1-jesse.brandeburg@intel.com> <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
In-Reply-To: <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Tue, 4 May 2021 10:29:09 -0400
Message-ID: <CAFki+L=D8aS_jub0KHAkfsnvvJ_w8_mMYbaHeZ-GkQF1s_0WDQ@mail.gmail.com>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when
 setting the hint
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
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

On Tue, May 4, 2021 at 8:15 AM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2021-05-01 03:18, Jesse Brandeburg wrote:
> > It was pointed out by Nitesh that the original work I did in 2014
> > to automatically set the interrupt affinity when requesting a
> > mask is no longer necessary. The kernel has moved on and no
> > longer has the original problem, BUT the original patch
> > introduced a subtle bug when booting a system with reserved or
> > excluded CPUs. Drivers calling this function with a mask value
> > that included a CPU that was currently or in the future
> > unavailable would generally not update the hint.
> >
> > I'm sure there are a million ways to solve this, but the simplest
> > one is to just remove a little code that tries to force the
> > affinity, as Nitesh has shown it fixes the bug and doesn't seem
> > to introduce immediate side effects.
>
> Unfortunately, I think there are quite a few other drivers now relying
> on this behaviour, since they are really using irq_set_affinity_hint()
> as a proxy for irq_set_affinity().

That's true.

> Partly since the latter isn't
> exported to modules, but also I have a vague memory of it being said
> that it's nice to update the user-visible hint to match when the
> affinity does have to be forced to something specific.

If you see the downside of it we are forcing the affinity to match the hint
mask without considering the default SMP affinity mask.

Also, we are repeating things here. First, we set certain mask for a device
IRQ via request_irq code path which does consider the default SMP mask but
then we are letting the driver over-write it.

If we want to set the IRQ mask in a certain way then it should be done at
the time of initial setup itself.

Do you know about a workload/use case that can show the benefit of
this behavior? As then we can try fixing it in the right way.

--
Thanks
Nitesh

