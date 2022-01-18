Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DF492125
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbiARIZW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 03:25:22 -0500
Received: from mail-ua1-f45.google.com ([209.85.222.45]:42760 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiARIZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:25:16 -0500
Received: by mail-ua1-f45.google.com with SMTP id p1so35034049uap.9;
        Tue, 18 Jan 2022 00:25:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wwyuk2lsKqIfL1r34uR4hiV5J4os/EyMOhjZZucVxAA=;
        b=I2i1nK3KE49ayM/k/7+QwdNB1Zw/V8rfgqp4QCmvWpqWYqVHuXXZLHkoGFbUNZwQoa
         5n58deiE9GIRaPOlMyVpmgpPhdeM6+XjSafr9D/U+9wMw7QnCwIKSHifBPKaKoKI7ghV
         GPjZiS0nW+lz1lWDERj4p5QQ60xQw9CHXpsjRJ1hmG+OzAfo7VdqIEEb5MXSZJ4tk/sN
         wK6lF0d8e/ePocJHJLPejU1HF8xld5m/zmPX0RLIdCeaaIPTzpkjHd0Jw8D0cXvhbrYZ
         FHbmY3rE4GmX6ZIIgeSp6MmNKyIiUbHsjMTOOage5nc+kV1Al0PTA5oAEiRtF6XNNBFK
         UC4A==
X-Gm-Message-State: AOAM531TjjIono2QQrSzMZER0NUpWw9YWmdyoa4VDcXGutV5AUI3N5Qk
        NMu4UvqkxsalSADZQSGZWKANBWSt+9lqXV/t
X-Google-Smtp-Source: ABdhPJxEapMDT1TLJpP3jj0kK0vs2RhIajlcXxONwhZS+EvdSgowj8ApkJ3nRAIXNWOHwgyRPrDJbQ==
X-Received: by 2002:ab0:e13:: with SMTP id g19mr9097770uak.135.1642494314740;
        Tue, 18 Jan 2022 00:25:14 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id j76sm4044397vke.27.2022.01.18.00.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 00:25:13 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id 2so10353317uax.10;
        Tue, 18 Jan 2022 00:25:13 -0800 (PST)
X-Received: by 2002:ab0:4d42:: with SMTP id k2mr7281422uag.78.1642494312957;
 Tue, 18 Jan 2022 00:25:12 -0800 (PST)
MIME-Version: 1.0
References: <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru> <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru> <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru> <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de> <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de> <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
In-Reply-To: <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 18 Jan 2022 09:25:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
Message-ID: <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
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
        Hans de Goede <hdegoede@redhat.com>,
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
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Mon, Jan 17, 2022 at 6:06 PM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Mon, Jan 17, 2022 at 02:08:19PM +0100, Geert Uytterhoeven wrote:
> > On Mon, Jan 17, 2022 at 12:49 PM Uwe Kleine-König
> > <u.kleine-koenig@pengutronix.de> wrote:
> > > > The logic in e.g. drivers/tty/serial/sh-sci.c and
> > > > drivers/spi/spi-rspi.c could be simplified and improved (currently
> > > > it doesn't handle deferred probe) if platform_get_irq_optional()
> > > > would return 0 instead of -ENXIO.

> > > Also for spi-rspi.c I don't see how platform_get_irq_byname_optional()
> > > returning 0 instead of -ENXIO would help. Please talk in patches.

[...]

> This is not a simplification, just looking at the line count and the
> added gotos. That's because it also improves error handling and so the
> effect isn't easily spotted.

Yes, it's larger because it adds currently missing error handling.

> What about the following idea (in pythonic pseudo code for simplicity):

No idea what you gain by throwing in a language that is irrelevant
to kernel programming (why no Rust? ;-)

> > > > So there are three reasons: because the absence of an optional IRQ
> > > > is not an error, and thus that should not cause (a) an error code
> > > > to be returned, and (b) an error message to be printed, and (c)
> > > > because it can simplify the logic in device drivers.
> > >
> > > I don't agree to (a). If the value signaling not-found is -ENXIO or 0
> > > (or -ENODEV) doesn't matter much. I wouldn't deviate from the return
> > > code semantics of platform_get_irq() just for having to check against 0
> > > instead of -ENXIO. Zero is then just another magic value.
> >
> > Zero is a natural magic value (also for pointers).
> > Errors are always negative.
> > Positive values are cookies (or pointers) associated with success.
>
> Yeah, the issue where we don't agree is if "not-found" is special enough
> to deserve the natural magic value. For me -ENXIO is magic enough to
> handle the absence of an irq line. I consider it even the better magic
> value.

It differs from other subsystems (clk, gpio, reset), which do return
zero on not found.
What's the point in having *_optional() APIs if they just return the
same values as the non-optional ones?


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
