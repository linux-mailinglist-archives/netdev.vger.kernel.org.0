Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7049060B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 11:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiAQKgM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 05:36:12 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:44866 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiAQKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 05:36:08 -0500
Received: by mail-vk1-f178.google.com with SMTP id b77so10050961vka.11;
        Mon, 17 Jan 2022 02:36:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8wbyaDOKHzyncR/a8atHHiwf57S6QrlnXekhvOqZ5Zc=;
        b=LSqfAKSEMaEAYGbunuoNsuAo80Rk3bWRnbog4vmP3JZLEh9uYSltN70uJc84BpJSr7
         JJnirAVOJlzWKyDEIR2Diay0j4XTt0t62ENC9pifrHEO7FBWiHhHxuDK1WzAc8e6ELXR
         kQ9mlj4U0HJfB2+KW8z5oG8eumwZ7pBma/5Dw/MfcUBQY6urYwF8smbH7H3q2qCyOWnZ
         WMftrgtX96eKLAO99UHB4hY/TEZK/0NkFFeXjMqVUQZMRIBvb4IgC5k585TkQC90Pjjl
         OCO4TUh6V49qlC5LMsMRqBmcDWSn9b1oJydqBYMjT6BdgJQWG8UIu4fo3Rdo+xKpbYJ/
         vCYw==
X-Gm-Message-State: AOAM5305tSrFltxA7gBSd0tqguB9hBRHUBFEH4OLNLs0dzL4jrmjEiQD
        BXv/dJZDl/cDrQpuSMLa9PFd1Pet6ZxLZku3
X-Google-Smtp-Source: ABdhPJy0WUl6ljrrNQay/fQ0XF0Z1LDo996FsF8bsiQ2Edql4XjhP64FvczIhYIxWKkP7rQimMMsaw==
X-Received: by 2002:a1f:2c54:: with SMTP id s81mr4062257vks.38.1642415766251;
        Mon, 17 Jan 2022 02:36:06 -0800 (PST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id b14sm3226412vkk.22.2022.01.17.02.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 02:36:04 -0800 (PST)
Received: by mail-ua1-f45.google.com with SMTP id c36so29466451uae.13;
        Mon, 17 Jan 2022 02:36:04 -0800 (PST)
X-Received: by 2002:ab0:4d42:: with SMTP id k2mr5738849uag.78.1642415764003;
 Mon, 17 Jan 2022 02:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru> <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru> <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru> <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
In-Reply-To: <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 17 Jan 2022 11:35:52 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
Message-ID: <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        platform-driver-x86@vger.kernel.org,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Mon, Jan 17, 2022 at 10:24 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Mon, Jan 17, 2022 at 09:41:42AM +0100, Geert Uytterhoeven wrote:
> > On Sat, Jan 15, 2022 at 9:22 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> > > On 1/14/22 11:22 PM, Uwe Kleine-König wrote:
> > > > You have to understand that for clk (and regulator and gpiod) NULL is a
> > > > valid descriptor that can actually be used, it just has no effect. So
> > > > this is a convenience value for the case "If the clk/regulator/gpiod in
> > > > question isn't available, there is nothing to do". This is what makes
> > > > clk_get_optional() and the others really useful and justifies their
> > > > existence. This doesn't apply to platform_get_irq_optional().
> > >
> > >    I do understand that. However, IRQs are a different beast with their
> > > own justifications...
> >
> > > > clk_get_optional() is sane and sensible for cases where the clk might be
> > > > absent and it helps you because you don't have to differentiate between
> > > > "not found" and "there is an actual resource".
> > > >
> > > > The reason for platform_get_irq_optional()'s existence is just that
> > > > platform_get_irq() emits an error message which is wrong or suboptimal
> > >
> > >    I think you are very wrong here. The real reason is to simplify the
> > > callers.
> >
> > Indeed.
>
> The commit that introduced platform_get_irq_optional() said:
>
>         Introduce a new platform_get_irq_optional() that works much like
>         platform_get_irq() but does not output an error on failure to
>         find the interrupt.
>
> So the author of 8973ea47901c81a1912bd05f1577bed9b5b52506 failed to
> mention the real reason? Or look at
> 31a8d8fa84c51d3ab00bf059158d5de6178cf890:
>
>         [...] use platform_get_irq_optional() to get second/third IRQ
>         which are optional to avoid below error message during probe:
>         [...]
>
> Look through the output of
>
>         git log -Splatform_get_irq_optional
>
> to find several more of these.

Commit 8973ea47901c81a1 ("driver core: platform: Introduce
platform_get_irq_optional()") and the various fixups fixed the ugly
printing of error messages that were not applicable.
In hindsight, probably commit 7723f4c5ecdb8d83 ("driver core:
platform: Add an error message to platform_get_irq*()") should have
been reverted instead, until a platform_get_irq_optional() with proper
semantics was introduced.  But as we were all in a hurry to kill
the non-applicable error message, we went for the quick and dirty fix.

> Also I fail to see how a caller of (today's) platform_get_irq_optional()
> is simpler than a caller of platform_get_irq() given that there is no
> semantic difference between the two. Please show me a single
> conversion from platform_get_irq to platform_get_irq_optional that
> yielded a simplification.

That's exactly why we want to change the latter to return 0 ;-)

> So you need some more effort to convince me of your POV.
>
> > Even for clocks, you cannot assume that you can always blindly use
> > the returned dummy (actually a NULL pointer) to call into the clk
> > API.  While this works fine for simple use cases, where you just
> > want to enable/disable an optional clock (clk_prepare_enable() and
> > clk_disable_unprepare()), it does not work for more complex use cases.
>
> Agreed. But for clks and gpiods and regulators the simple case is quite
> usual. For irqs it isn't.

It is for devices that can have either separate interrupts, or a single
multiplexed interrupt.

The logic in e.g. drivers/tty/serial/sh-sci.c and
drivers/spi/spi-rspi.c could be simplified and improved (currently
it doesn't handle deferred probe) if platform_get_irq_optional()
would return 0 instead of -ENXIO.

> And if you cannot blindly use the dummy, then you're not the targetted
> caller of *_get_optional() and should better use *_get() and handle
> -ENODEV explicitly.

No, because the janitors tend to consolidate error message handling,
by moving the printing up, inside the *_get() methods.  That's exactly
what happened here.
So there are three reasons: because the absence of an optional IRQ
is not an error, and thus that should not cause (a) an error code
to be returned, and (b) an error message to be printed, and (c)
because it can simplify the logic in device drivers.

Commit 8973ea47901c81a1 ("driver core: platform: Introduce
platform_get_irq_optional()") fixed (b), but didn't address (a) and
(c).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
