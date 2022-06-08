Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E632542EE2
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiFHLLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiFHLKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:10:44 -0400
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D712200B2;
        Wed,  8 Jun 2022 04:10:03 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id l204so35903331ybf.10;
        Wed, 08 Jun 2022 04:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pc8sxjRlyZLiUc2vjV2mNnQdPSrQGggcOwRrmtPvRmQ=;
        b=qe4IyOMZ1enGiEf1hklCCFUi3b60/6BlA5Lg/UspYBtAOyv0XMu9/oKSbuc3JFHEYf
         K5HVWjr13x2ZZqbt6+Qgb0IhV/GR4LEH2dKXjk8WnFsnvCIsp7+DQbmAsd6VWECEJvbK
         4dhpMtk5cK2w69gqeS9/p/96DXD4OGZ4GI6JtQcfG/CVNgATHQg/HRSIBYR+czqTGTeU
         Om5DmRJ8AqmFUEVwY/uWkeApI7PEUjazHu+sZYZ5GRaQq7421CHYTLNR6BVA+qf83n9J
         w5EkumHngZxtsvCUBkV00gXXseSCSfN1A8KVNKKYJBhg44gP1DliJn771LN6Cgbr+css
         LNqg==
X-Gm-Message-State: AOAM531ouiHgI3ieRHcSXolGy+SBFr/HQxFyrRxFaZiQKFvTizm/yGR7
        eUw9Aiq1P1E8QvW42APNoJ/wj0PudKoXEqEmnOk=
X-Google-Smtp-Source: ABdhPJwRKE+6ldZEiFkLjFAW/hFfOibVBLhzJ4mgNxUf5xFcMaFnctaDFCd44iSd/rY55Z6W8yVwkhAYYTiu/pGflk8=
X-Received: by 2002:a25:84ca:0:b0:65c:b5a4:3d0a with SMTP id
 x10-20020a2584ca000000b0065cb5a43d0amr34085830ybm.137.1654686601554; Wed, 08
 Jun 2022 04:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1654680790.git.lukas@wunner.de> <CAJZ5v0i1p=oReS5Ki69-uOLQNBu2Y=MkqDQ4fUU-ih=n_kshwQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0i1p=oReS5Ki69-uOLQNBu2Y=MkqDQ4fUU-ih=n_kshwQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 8 Jun 2022 13:09:50 +0200
Message-ID: <CAJZ5v0jocgtgZxA2wiDTbtOypQFy2WeHRCeNn9U4cvCZ_p48Bg@mail.gmail.com>
Subject: Re: [PATCH net v2 0/1] PHY interruptus horribilis
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        netdev <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 12:35 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jun 8, 2022 at 11:52 AM Lukas Wunner <lukas@wunner.de> wrote:
> >
> > Andrew Lunn (PHY maintainer) asked me to resend this patch and cc the
> > IRQ maintainer.  I'm also cc'ing PM maintainers for good measure.
> >
> > The patch addresses an issue with PHY interrupts occurring during a
> > system sleep transition after the PHY has already been suspended.
> >
> > The IRQ subsystem uses an internal flag IRQD_WAKEUP_ARMED to avoid
> > handling such interrupts, but it's not set until suspend_device_irqs()
> > is called during the ->suspend_noirq() phase.  That's too late in this
> > case as PHYs are suspended in the ->suspend() phase.  And there's
> > no external interface to set the flag earlier.
>
> Yes, it is not there intentionally.
>
> Strictly speaking, IRQD_WAKEUP_ARMED is there to indicate to the IRQ
> subsystem that the given IRQ is a system wakeup one and has been left
> enabled specifically in order to signal system wakeup.  It allows the
> IRQ to trigger between suspend_device_irqs() and resume_device_irqs()
> exactly once, which causes the system to wake up from suspend-to-idle
> (that's the primary use case for it) or aborts system suspends in
> progress.
>
> As you have noticed, it is set automatically by suspend_device_irqs()
> if the given IRQ has IRQD_WAKEUP_STATE which is the case when it has
> been enabled for system wakeup.
>
> > As I'm lacking access to the flag, I'm open coding its functionality
> > in this patch.  Is this the correct approach or should I instead look
> > into providing an external interface to the flag?
>
> The idea is that the regular IRQ "action" handler will run before
> suspend_device_irqs(), so it should take care of signaling wakeup if
> need be.  IRQD_WAKEUP_ARMED to trigger wakeup when IRQ "action"
> handlers don't run.

That said IMV there could be a wrapper around suspend_device_irq() to
mark a specific IRQ as "suspended" before running
suspend_device_irqs(), but that would require adding "suspend depth"
to struct irq_desc, so the IRQ is not "resumed" prematurely by
resume_device_irqs().  And there needs to be an analogous wrapper
around resume_irq() for the resume path.

Does the single prospective user justify this?
