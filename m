Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C36542E00
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiFHKjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbiFHKi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:38:28 -0400
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20592AC570;
        Wed,  8 Jun 2022 03:36:07 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-30fdbe7467cso169047797b3.1;
        Wed, 08 Jun 2022 03:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9inqKolylwY+9CN5LJBsj0ieLUPaFRDgrwMAar4kegU=;
        b=Jlxd/4InTGQ3arVIG1dE5u8RLbDijR85cJdJkLZxMfEDJ0LcqaK8pNUmD7G/4Kuipa
         0/m6VAeFfaa4qNn4iRS9qrtJ07B8X631E6f1ByRrqjcAD2gANeexzTDAbwmOMadIF/HM
         qqPtd3bN3doJ/IZKHM+Y1z6nrBOoXefUwp9RzqviGn8cDK5uDbrC9vG+Olh5lusSiLWY
         7uNN3+deX6pmOlUo6aN8dxPVGeahcTnJe4MwHaztIwXEMA9i0PPi6uqThYY7HbtI3Mry
         dxCsmyg4rvNtH9iAUYS8n7E6xfGRw1GJr6K+jcmXaqV2xxtGCALShmCaJoYJD2hx/G7+
         hvCQ==
X-Gm-Message-State: AOAM531GBASXUwklrtisXb1YzJoUP5dL9DfeDGq6MxPZH1pmJe/TPF5K
        QBG7m9BbO0JDNbCP561XOJyDeRYFc+tn6Su8Z8A=
X-Google-Smtp-Source: ABdhPJwcDdMr9FPIGNqccLkzhIg8CyJ/eP0qJtvoHBQxHOyr2FeWxm2Z8z0maGBLjLLKvvAqU+8gR1ZZ0kEfoTeUVss=
X-Received: by 2002:a81:260a:0:b0:2f4:ca82:a42f with SMTP id
 m10-20020a81260a000000b002f4ca82a42fmr36701040ywm.149.1654684546217; Wed, 08
 Jun 2022 03:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1654680790.git.lukas@wunner.de>
In-Reply-To: <cover.1654680790.git.lukas@wunner.de>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 8 Jun 2022 12:35:35 +0200
Message-ID: <CAJZ5v0i1p=oReS5Ki69-uOLQNBu2Y=MkqDQ4fUU-ih=n_kshwQ@mail.gmail.com>
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

On Wed, Jun 8, 2022 at 11:52 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> Andrew Lunn (PHY maintainer) asked me to resend this patch and cc the
> IRQ maintainer.  I'm also cc'ing PM maintainers for good measure.
>
> The patch addresses an issue with PHY interrupts occurring during a
> system sleep transition after the PHY has already been suspended.
>
> The IRQ subsystem uses an internal flag IRQD_WAKEUP_ARMED to avoid
> handling such interrupts, but it's not set until suspend_device_irqs()
> is called during the ->suspend_noirq() phase.  That's too late in this
> case as PHYs are suspended in the ->suspend() phase.  And there's
> no external interface to set the flag earlier.

Yes, it is not there intentionally.

Strictly speaking, IRQD_WAKEUP_ARMED is there to indicate to the IRQ
subsystem that the given IRQ is a system wakeup one and has been left
enabled specifically in order to signal system wakeup.  It allows the
IRQ to trigger between suspend_device_irqs() and resume_device_irqs()
exactly once, which causes the system to wake up from suspend-to-idle
(that's the primary use case for it) or aborts system suspends in
progress.

As you have noticed, it is set automatically by suspend_device_irqs()
if the given IRQ has IRQD_WAKEUP_STATE which is the case when it has
been enabled for system wakeup.

> As I'm lacking access to the flag, I'm open coding its functionality
> in this patch.  Is this the correct approach or should I instead look
> into providing an external interface to the flag?

The idea is that the regular IRQ "action" handler will run before
suspend_device_irqs(), so it should take care of signaling wakeup if
need be.  IRQD_WAKEUP_ARMED to trigger wakeup when IRQ "action"
handlers don't run.

> Side note: suspend_device_irqs() and resume_device_irqs() have been
> exported since forever even though there's no module user...

Well, that's a mistake.
