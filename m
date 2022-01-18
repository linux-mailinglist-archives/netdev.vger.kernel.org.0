Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E0492612
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbiARMti convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 07:49:38 -0500
Received: from mail-ua1-f49.google.com ([209.85.222.49]:35487 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiARMtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:49:31 -0500
Received: by mail-ua1-f49.google.com with SMTP id m90so36320088uam.2;
        Tue, 18 Jan 2022 04:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iDNGF1VjVomGlE1aVlmhPbvwByegTECQGcsrxubfQG0=;
        b=W/7+KwcQIFe8k9do6GnoupOVJaOKBdiP+MrAUzGwizq4jkG1DvOd/PQS8vg7vJJvPe
         8C5XbpuNcDb8ZlT+gBIZGaYfLBDaASe9KEv2NsKpjpF2tRaZ+Zuud8NIJms2l4qkzLAx
         XMv9JWaVH9cGPKjKWYMq/5DePXPe+QcRDbfM7E/Ty5DHg2hX3jTvc+WkxeBZAwkUGvve
         QRei+gV7soYC+7p6+3G6d1wC+bgK5TkBu1QySj3AJkSRF2gvILWYsUQfNeBdCNFetwxb
         1YNiYjF+yFkbraOPVF38W15G82u/rOkTNnSpQ0FS+TlAQ0nrg9CvT8YPJTzh++cG9Tv2
         lZ5A==
X-Gm-Message-State: AOAM531I+1ECNNQTj+97N5eGsVOavtQ4zTarjbORuoCQFkwudfNUGeEL
        ykKgZwG8KROlSfpcRJvFjxNtHdQQD6iLJ4YM
X-Google-Smtp-Source: ABdhPJwKQbCOkjDtdikM1lfRv1KCWaWVwhaMtYkyK+iOxRUckVe3GwFbVQNSVQ9kAuVjm+afJgCLKg==
X-Received: by 2002:a05:6102:ecf:: with SMTP id m15mr8610496vst.68.1642510169047;
        Tue, 18 Jan 2022 04:49:29 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id p14sm3586095uad.20.2022.01.18.04.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 04:49:27 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id c36so36154877uae.13;
        Tue, 18 Jan 2022 04:49:27 -0800 (PST)
X-Received: by 2002:a05:6102:3581:: with SMTP id h1mr9266907vsu.5.1642510166831;
 Tue, 18 Jan 2022 04:49:26 -0800 (PST)
MIME-Version: 1.0
References: <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru> <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de> <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de> <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de> <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
 <20220118090913.pjumkq4zf4iqtlha@pengutronix.de> <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
 <20220118120806.pbjsat4ulg3vnhsh@pengutronix.de>
In-Reply-To: <20220118120806.pbjsat4ulg3vnhsh@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 18 Jan 2022 13:49:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWkwV9XE_R5FZ=jPtDwLpDbEngG6+X2JmiDJCZJZvUjYA@mail.gmail.com>
Message-ID: <CAMuHMdWkwV9XE_R5FZ=jPtDwLpDbEngG6+X2JmiDJCZJZvUjYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Tue, Jan 18, 2022 at 1:08 PM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Tue, Jan 18, 2022 at 10:37:25AM +0100, Geert Uytterhoeven wrote:
> > On Tue, Jan 18, 2022 at 10:09 AM Uwe Kleine-König
> > <u.kleine-koenig@pengutronix.de> wrote:
> > > For the (clk|gpiod|regulator)_get_optional() you don't have to check
> > > against the magic not-found value (so no implementation detail magic
> > > leaks into the caller code) and just pass it to the next API function.
> > > (And my expectation would be that if you chose to represent not-found by
> > > (void *)66 instead of NULL, you won't have to adapt any user, just the
> > > framework internal checks. This is a good thing!)
> >
> > Ah, there is the wrong assumption: drivers sometimes do need to know
> > if the resource was found, and thus do need to know about (void *)66,
> > -ENODEV, or -ENXIO.  I already gave examples for IRQ and clk before.
> > I can imagine these exist for gpiod and regulator, too, as soon as
> > you go beyond the trivial "enable" and "disable" use-cases.
>
> My premise is that every user who has to check for "not found"
> explicitly should not use (clk|gpiod)_get_optional() but
> (clk|gpiod)_get() and do proper (and explicit) error handling for
> -ENODEV. (clk|gpiod)_get_optional() is only for these trivial use-cases.
>
> > And 0/NULL vs. > 0 is the natural check here: missing, but not
> > an error.
>
> For me it it 100% irrelevant if "not found" is an error for the query
> function or not. I just have to be able to check for "not found" and
> react accordingly.
>
> And adding a function
>
>         def platform_get_irq_opional():
>                 ret = platform_get_irq()
>                 if ret == -ENXIO:
>                         return 0
>                 return ret
>
> it's not a useful addition to the API if I cannot use 0 as a dummy
> because it doesn't simplify the caller enough to justify the additional
> function.
>
> The only thing I need to be able is to distinguish the cases "there is
> an irq", "there is no irq" and anything else is "there is a problem I
> cannot handle and so forward it to my caller". The semantic of
> platform_get_irq() is able to satisfy this requirement[1], so why introduce
> platform_get_irq_opional() for the small advantage that I can check for
> not-found using
>
>         if (!irq)
>
> instead of
>
>         if (irq != -ENXIO)
>
> ? The semantic of platform_get_irq() is easier ("Either a usable
> non-negative irq number or a negative error number") compared to
> platform_get_irq_optional() ("Either a usable positive irq number or a
> negative error number or 0 meaning not found"). Usage of
> platform_get_irq() isn't harder or more expensive (neither for a human
> reader nor for a maching running the resulting compiled code).
> For a human reader
>
>         if (irq != -ENXIO)
>
> is even easier to understand because for
>
>         if (!irq)
>
> they have to check where the value comes from, see it's
> platform_get_irq_optional() and understand that 0 means not-found.

"vIRQ zero does not exist."

> This function just adds overhead because as a irq framework user I have
> to understand another function. For me the added benefit is too small to
> justify the additional function. And you break out-of-tree drivers.
> These are all no major counter arguments, but as the advantage isn't
> major either, they still matter.
>
> Best regards
> Uwe
>
> [1] the only annoying thing is the error message.

So there's still a need for two functions.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
