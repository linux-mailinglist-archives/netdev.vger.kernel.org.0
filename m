Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A4148E7A9
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiANJj1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 04:39:27 -0500
Received: from mail-vk1-f182.google.com ([209.85.221.182]:39619 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiANJjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 04:39:23 -0500
Received: by mail-vk1-f182.google.com with SMTP id n14so4303363vkk.6;
        Fri, 14 Jan 2022 01:39:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XIsXuJfmE8JES6Mbtb18c2n3rWZVUZhPWhasZQeRi6Q=;
        b=B6fVIblE2YvZVeCArGcMUv0EJNHL+C2rkW//YimybgZ4VFOF6qnKGPJBYjiX+q9Dq5
         nJVlZ2LbWqXpD7YGOyGSeudPe2r8bTHf3AuHH/E/JTEQch+crQsQwq7Xesx6PJuRoHVG
         vZLoGUjBK4/tgccEHiWg5NGcjFeo/ZYdd/pZ8EadRA5wmgmCgLLaxqlpFck3zhsk9R3g
         s5LGB2neA5o/2//SrAax7o4hmZkvRNgswZ5FI80jKNxgcY0VxYt74iZSKZnFkopMg/Ad
         PWLhMOBCniba9fgx5U5sdkjls0O8hAWjVUS70uDszzCGQvcy7c6UaGPWrEX+dVtkV8jd
         iOSg==
X-Gm-Message-State: AOAM532dOoWuvtPRgS471+cj2DoVR7o0lPqEF04Zasu/K8Gtvx/nMOFM
        FIhIPsgx3PVt64ddBzE7FJ0b535mFnUbhej7
X-Google-Smtp-Source: ABdhPJyk3O8GzDxpL3/PrxHmPJiIYnb05POlLBdMiX4/E5+LHj71bMHAwA4rtBlCUD6Pjl/GZG0tmg==
X-Received: by 2002:a05:6122:208a:: with SMTP id i10mr366113vkd.16.1642153161863;
        Fri, 14 Jan 2022 01:39:21 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id x128sm2072722vkx.14.2022.01.14.01.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 01:39:19 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id i5so15890425uaq.10;
        Fri, 14 Jan 2022 01:39:19 -0800 (PST)
X-Received: by 2002:a05:6102:3581:: with SMTP id h1mr3716211vsu.5.1642153159149;
 Fri, 14 Jan 2022 01:39:19 -0800 (PST)
MIME-Version: 1.0
References: <20220110195449.12448-1-s.shtylyov@omp.ru> <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de> <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru> <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
In-Reply-To: <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jan 2022 10:39:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVcMNMYf82-rz8_057BGwYWyPyhjAh3e9ynrv82GMiHvg@mail.gmail.com>
Message-ID: <CAMuHMdVcMNMYf82-rz8_057BGwYWyPyhjAh3e9ynrv82GMiHvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
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
        Takashi Iwai <tiwai@suse.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
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

On Fri, Jan 14, 2022 at 10:26 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Thu, Jan 13, 2022 at 11:35:34PM +0300, Sergey Shtylyov wrote:
> > On 1/13/22 12:45 AM, Mark Brown wrote:
> > >>> To me it sounds much more logical for the driver to check if an
> > >>> optional irq is non-zero (available) or zero (not available), than to
> > >>> sprinkle around checks for -ENXIO. In addition, you have to remember
> > >>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
> > >>> (or some other error code) to indicate absence. I thought not having
> > >>> to care about the actual error code was the main reason behind the
> > >>> introduction of the *_optional() APIs.
> > >
> > >> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
> > >> that you can handle an absent GPIO (or clk) as if it were available.
> >
> >    Hm, I've just looked at these and must note that they match 1:1 with
> > platform_get_irq_optional(). Unfortunately, we can't however behave the
> > same way in request_irq() -- because it has to support IRQ0 for the sake
> > of i8253 drivers in arch/...
>
> Let me reformulate your statement to the IMHO equivalent:
>
>         If you set aside the differences between
>         platform_get_irq_optional() and gpiod_get_optional(),
>         platform_get_irq_optional() is like gpiod_get_optional().
>
> The introduction of gpiod_get_optional() made it possible to simplify
> the following code:
>
>         reset_gpio = gpiod_get(...)
>         if IS_ERR(reset_gpio):
>                 error = PTR_ERR(reset_gpio)
>                 if error != -ENDEV:
>                         return error
>         else:
>                 gpiod_set_direction(reset_gpiod, INACTIVE)
>
> to
>
>         reset_gpio = gpiod_get_optional(....)
>         if IS_ERR(reset_gpio):
>                 return reset_gpio
>         gpiod_set_direction(reset_gpiod, INACTIVE)
>
> and I never need to actually know if the reset_gpio actually exists.
> Either the line is put into its inactive state, or it doesn't exist and
> then gpiod_set_direction is a noop. For a regulator or a clk this works
> in a similar way.
>
> However for an interupt this cannot work. You will always have to check
> if the irq is actually there or not because if it's not you cannot just
> ignore that. So there is no benefit of an optional irq.
>
> Leaving error message reporting aside, the introduction of
> platform_get_irq_optional() allows to change
>
>         irq = platform_get_irq(...);
>         if (irq < 0 && irq != -ENXIO) {
>                 return irq;
>         } else if (irq >= 0) {
>                 ... setup irq operation ...
>         } else { /* irq == -ENXIO */
>                 ... setup polling ...
>         }
>
> to
>
>         irq = platform_get_irq_optional(...);
>         if (irq < 0 && irq != -ENXIO) {
>                 return irq;
>         } else if (irq >= 0) {
>                 ... setup irq operation ...
>         } else { /* irq == -ENXIO */
>                 ... setup polling ...
>         }
>
> which isn't a win. When changing the return value as you suggest, it can
> be changed instead to:
>
>         irq = platform_get_irq_optional(...);
>         if (irq < 0) {
>                 return irq;
>         } else if (irq > 0) {
>                 ... setup irq operation ...
>         } else { /* irq == 0 */
>                 ... setup polling ...
>         }
>
> which is a tad nicer. If that is your goal however I ask you to also
> change the semantic of platform_get_irq() to return 0 on "not found".

Please don't make that change. If platform_get_irq() would return 0 on
"not found", all existing users have to be changed to:

        irq = platform_get_irq(...);
        if (irq < 0) {
                return irq;
        } else if (!irq) {
                return -ENOENT;
        } else {
                ... setup irq operation ...
        }

If the IRQ is not optional, there should be an error code when it is
not present. This keeps error handling simple.

The _optional() difference lies in the zero/NULL vs. error code in
case of not present.

> Note the win is considerably less compared to gpiod_get_optional vs
> gpiod_get however. And then it still lacks the semantic of a dummy irq
> which IMHO forfeits the right to call it ..._optional().
>
> Now I'm unwilling to continue the discussion unless there pops up a
> suggestion that results in a considerable part (say > 10%) of the
> drivers using platform_get_irq_optional not having to check if the
> return value corresponds to "not found".

Usually drivers do have to check if the interrupt was present or
not, because they may have to change the operation of the driver,
depending on interrupt-based or timer/polling-based processing.

Clocks, regulators, and resets are different, as their absence is
really a no-op.  The absence of an interrupt is not a no-op (except
for the separate interrupts vs. a single muxed interrupt case).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
