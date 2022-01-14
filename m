Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB65648E7F6
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiANJ7K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 04:59:10 -0500
Received: from mail-ua1-f54.google.com ([209.85.222.54]:35506 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiANJ7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 04:59:05 -0500
Received: by mail-ua1-f54.google.com with SMTP id m90so16094884uam.2;
        Fri, 14 Jan 2022 01:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LMpobQFf1iaA0D70o2w2ggZn7pjngkhXQg858+CLGTw=;
        b=iNuRv7X+axQkS087/SEyVRfO807oDY8shZhs/RwbIOXrSJwDV4ivcCA8aQXWl04XYX
         0xvRFdm45/m3AH4F6sxbOGY18vGQ2l6/oslhdN25IV2CEKO714zW5bsExRdX3RfwolLx
         JOZ8Q2zCT/ZbmuUmFJtoLtKwr5MtpKkiuujFgB9cwtyyMz7kjl4E+gjXU6RAH9G6s8g1
         LtcYRGzW3Y5fNoXLxX4i3HiicVj9EHd2ZOyNcOZfA87BCQYltk85FuYKaCBSzHDZ4OeQ
         e9xAelfLcLlrvyDQHKJNjblWo5Nf89OJdMHR4liKWiRYvo+IGKjZbjYzvvyoO5COMZ6w
         Q9wg==
X-Gm-Message-State: AOAM532sLVmq0HXIdflqmaOJLCYgtWMac8I4GsATtNywZZTwzimhwn5A
        /VD3wdy52bHeuAx5iNkeZdGttDvg1uOEqEhH
X-Google-Smtp-Source: ABdhPJxHh8EdXSh3VBEjuVDDfqaR9RmxXk44chjxPH7GeQ/Gjo5pr5JcrJn3S8edkLsVjYbwAobZ+w==
X-Received: by 2002:a67:e905:: with SMTP id c5mr3767905vso.68.1642154343755;
        Fri, 14 Jan 2022 01:59:03 -0800 (PST)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id u33sm2226584uau.7.2022.01.14.01.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 01:59:03 -0800 (PST)
Received: by mail-ua1-f48.google.com with SMTP id p1so16004267uap.9;
        Fri, 14 Jan 2022 01:59:02 -0800 (PST)
X-Received: by 2002:a67:e905:: with SMTP id c5mr3767888vso.68.1642154342466;
 Fri, 14 Jan 2022 01:59:02 -0800 (PST)
MIME-Version: 1.0
References: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de> <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de> <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de> <YeCI47ltlWzjzjYy@sirena.org.uk>
 <1df04d74-8aa2-11f1-54e9-34d0e8f4e58b@omp.ru> <20220113224319.akljsjtu7ps75vun@pengutronix.de>
In-Reply-To: <20220113224319.akljsjtu7ps75vun@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jan 2022 10:58:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWjo36UGde3g5ysdXpLJn=mrPp31SDODuQNPUqoc-ARrQ@mail.gmail.com>
Message-ID: <CAMuHMdWjo36UGde3g5ysdXpLJn=mrPp31SDODuQNPUqoc-ARrQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
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

On Thu, Jan 13, 2022 at 11:43 PM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Thu, Jan 13, 2022 at 11:57:43PM +0300, Sergey Shtylyov wrote:
> > On 1/13/22 11:17 PM, Mark Brown wrote:
> > >> The subsystems regulator, clk and gpio have the concept of a dummy
> > >> resource. For regulator, clk and gpio there is a semantic difference
> > >> between the regular _get() function and the _get_optional() variant.
> > >> (One might return the dummy resource, the other won't. Unfortunately
> > >> which one implements which isn't the same for these three.) The
> > >> difference between platform_get_irq() and platform_get_irq_optional() is
> > >> only that the former might emit an error message and the later won't.
> >
> >    This is only a current difference but I'm still going to return 0 ISO
> > -ENXIO from latform_get_irq_optional(), no way I'd leave that -ENXIO there
> > alone... :-)
>
> This would address a bit of the critic in my commit log. But as 0 isn't
> a dummy value like the dummy values that exist for clk, gpiod and
> regulator I still think that the naming is a bad idea because it's not
> in the spirit of the other *_get_optional functions.
>
> Seeing you say that -ENXIO is a bad return value for
> platform_get_irq_optional() and 0 should be used instead, I wonder why
> not changing platform_get_irq() to return 0 instead of -ENXIO, too.
> This question is for now only about a sensible semantic. That actually
> changing platform_get_irq() is probably harder than changing
> platform_get_irq_optional() is a different story.
>
> If only platform_get_irq_optional() is changed and given that the
> callers have to do something like:
>
>         if (this_irq_exists()):
>                 ... (e.g. request_irq)
>         else:
>                 ... (e.g. setup polling)
>
> I really think it's a bad idea that this_irq_exists() has to be
> different for platform_get_irq() vs. platform_get_irq_optional().

For platform_get_irq(), the IRQ being absent is an error condition,
hence it should return an error code.
For platform_get_irq_optional(), the IRQ being absent is not an error
condition, hence it should not return an error code, and 0 is OK.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
