Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D645B391303
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhEZIwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:52:31 -0400
Received: from mail-ua1-f42.google.com ([209.85.222.42]:46894 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhEZIwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:52:30 -0400
Received: by mail-ua1-f42.google.com with SMTP id h26so340746uab.13;
        Wed, 26 May 2021 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftj/o/FDlLZjvveU5gflHCydxVxy9/duOHSuWLsKuds=;
        b=gzUBebI1WuB/5fkUx1y0oflbKBO2nJRvgKevQ/1JqUA1aPixRsQ6XgY/E+PGl8YFDb
         v6YXbmpQFoXXfjX9RnX1PIAnnXPOlmmuqsSJMQ0/QwRjW0m6/lo/b5eEQKpLzDa+3K+G
         CpmFqw8dQUzeJORNcWefueRBdAD6znRBePDhcBH3aECy5Qdsoyzsncmz8AsvqDGnS/AT
         cexFtZLcaUFwLO/Fzu9ZkDc8UajoqK4yRvUiuv7XzGoalsHpBhiOTkV1rN6NxTTQcjBY
         PvOSA7EnnucGnAY+FjyX1LD+YuYYZF2+NL0gIIOeJa6W/n6S9MBy40PCx6KAIhnLaZxq
         mqrQ==
X-Gm-Message-State: AOAM530/mpYKMt+3kw+JWnyAo4LXGfKlrxCVsg8sQoHi4cOYqB6jTpKD
        jQXOFBTcNNnAT46FiffZkFUL5RaZbFHpP6bwrfU3LpM8
X-Google-Smtp-Source: ABdhPJywUZ6Xwv+zij4MSQ000T5eibp+TpLy3YyyGoFqj+kf4ejbTke4WZLjWrCgAdHGlnISxwMlbpFtCE1QmEgp5j8=
X-Received: by 2002:ab0:2a8b:: with SMTP id h11mr31904723uar.4.1622019058834;
 Wed, 26 May 2021 01:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org> <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
 <6c522f8116f54fa6f23a2d217d966c5a@kernel.org> <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
 <8735u9x6sb.wl-maz@kernel.org> <CAMuHMdUBwcB-v0ugCPB3D6dbttiSbqQeHgNrr+r331ntRrfiAw@mail.gmail.com>
 <871r9tx5dq.wl-maz@kernel.org>
In-Reply-To: <871r9tx5dq.wl-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 May 2021 10:50:47 +0200
Message-ID: <CAMuHMdVFE=RB5wPUi9PH5WeQPSYfcg+ugKigB4nAo9yotO+WYg@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To:     Marc Zyngier <maz@kernel.org>
Cc:     jianyong.wu@arm.com, netdev <netdev@vger.kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>, justin.he@arm.com,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Wed, May 26, 2021 at 10:32 AM Marc Zyngier <maz@kernel.org> wrote:
> On Wed, 26 May 2021 09:18:27 +0100,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, May 26, 2021 at 10:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > On Wed, 26 May 2021 08:52:42 +0100,
> > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > > > > > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > > >> From: Jianyong Wu <jianyong.wu@arm.com>
> > > > > >
> > > > > >> --- a/drivers/ptp/Kconfig
> > > > > >> +++ b/drivers/ptp/Kconfig
> > > > > >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> > > > > >>  config PTP_1588_CLOCK_KVM
> > > > > >>         tristate "KVM virtual PTP clock"
> > > > > >>         depends on PTP_1588_CLOCK
> > > > > >> -       depends on KVM_GUEST && X86
> > > > > >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> > > > > >> ARM_ARCH_TIMER)
> > > > > >
> > > > > > Why does this not depend on KVM_GUEST on ARM?
> > > > > > I.e. shouldn't the dependency be:
> > > > > >
> > > > > >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> > > > > >
> > > > > > ?
> > > > >
> > > > > arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> > > > > and KVM/arm64 doesn't know about this configuration symbol.
> > > >
> > > > OK.
> > > >
> > > > Does PTP_1588_CLOCK_KVM need to default to yes?
> > > > Perhaps only on X86, to maintain the status quo?
> > >
> > > I think I don't really understand the problem you are trying to
> > > solve. Is it that 'make oldconfig' now asks you about this new driver?
> > > Why is that an issue?
> >
> > My first "problem" was that it asked about this new driver on
> > arm/arm64, while I assumed there were some missing dependencies
> > (configuring a kernel should not ask useless questions).  That turned
> > out to be a wrong assumption, so there is no such problem here.
> >
> > The second problem is "default y": code that is not critical should
> > not be enabled by default.  Hence my last question.
>
> I think consistency between architectures is important. Certainly,
> distributions depend on that, and we otherwise end-up with distro
> kernels missing functionalities.
>
> The notion of "critical" is also pretty relative. defconfig contains a

I'm not talking about defconfig, but about "default y" in defconfig.

> gazillion of things that are not critical to most people, for example,
> and yet misses a bunch of things that are needed to boot on some of my
> systems.

Perhaps those should be added, so those systems can be tested using
defconfig?  At least for arm64, I think that's aligned with the
arm64 defconfig policy.

> That's just to say that I find it difficult to make that choice from
> the PoV of a kernel hacker. I'm personally more inclined to leave
> things enabled and let people *disable* things if they want to reduce
> the footprint of their kernel.

The standard question to respond to w.r.t. "default y" is: "Why is
your feature so special that it needs to be enabled by default?",
which implies "default y" is the exception, not the rule.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
