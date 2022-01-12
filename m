Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28CA48C243
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352527AbiALK1W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Jan 2022 05:27:22 -0500
Received: from mail-ua1-f44.google.com ([209.85.222.44]:41930 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiALK1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:27:18 -0500
Received: by mail-ua1-f44.google.com with SMTP id p37so3799118uae.8;
        Wed, 12 Jan 2022 02:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bq/EV5whRByTBzcA7NkMG0ZHqS/XeQEEEioGL5IxVZo=;
        b=mxzSyfrU8iycdk9S9/jrAZvnR8hEGprGOwr/08lzaZlTw5/J6kavgPF9ZzrfVNLIzG
         P7dQYHcWu0/vAGa45uyXC6a+sqtVLhhncsSCGE3RoSQOzvJ8HiHpqYnRSR/0nhV0JCT0
         KEQbgFF0BeyPDG0P1um8J8jEzItzA5z/BGBH1euUb/HSQ0jHXH9deWkL2AESaPq4lDvF
         URresB7v7p3/KXiI8hZnQdptFbaQizJ8erVysOLR+oR5KiVUkSHCZfLeAOk00w/oSwgn
         BAcrPrqEuDr6t2V9mc6fsVTFXkeC4Og+r9Oznuy1xDD+wB5wpuXjsd7rMwdjGvrh9ww5
         t5WA==
X-Gm-Message-State: AOAM531/qcYDI+mLGOtzlm5qIEZZeWyhZJt168BJfrc2CCOSHuBS8DAM
        cSX0j9l9h6AmYCmTklQdH9y78hf34Rv19Tay
X-Google-Smtp-Source: ABdhPJzW97cz+iHtzbS3cGrOou77jysR40GtKoHkBfdaDUtOQfjGlRg+dPc9J8qUabKlvsh5wOvv/A==
X-Received: by 2002:a05:6102:241b:: with SMTP id j27mr133180vsi.66.1641983236805;
        Wed, 12 Jan 2022 02:27:16 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id b8sm7758709vsl.19.2022.01.12.02.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 02:27:15 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id p37so3798919uae.8;
        Wed, 12 Jan 2022 02:27:14 -0800 (PST)
X-Received: by 2002:a05:6102:21dc:: with SMTP id r28mr3809205vsg.57.1641983234508;
 Wed, 12 Jan 2022 02:27:14 -0800 (PST)
MIME-Version: 1.0
References: <20220110195449.12448-1-s.shtylyov@omp.ru> <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com> <20220112085009.dbasceh3obfok5dc@pengutronix.de>
In-Reply-To: <20220112085009.dbasceh3obfok5dc@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 11:27:02 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
Message-ID: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
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
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        platform-driver-x86@vger.kernel.org,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Wed, Jan 12, 2022 at 9:51 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Wed, Jan 12, 2022 at 09:33:48AM +0100, Geert Uytterhoeven wrote:
> > On Mon, Jan 10, 2022 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-König wrote:
> > > > On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > > > > This patch is based on the former Andy Shevchenko's patch:
> > > > >
> > > > > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
> > > > >
> > > > > Currently platform_get_irq_optional() returns an error code even if IRQ
> > > > > resource simply has not been found. It prevents the callers from being
> > > > > error code agnostic in their error handling:
> > > > >
> > > > >     ret = platform_get_irq_optional(...);
> > > > >     if (ret < 0 && ret != -ENXIO)
> > > > >             return ret; // respect deferred probe
> > > > >     if (ret > 0)
> > > > >             ...we get an IRQ...
> > > > >
> > > > > All other *_optional() APIs seem to return 0 or NULL in case an optional
> > > > > resource is not available. Let's follow this good example, so that the
> > > > > callers would look like:
> > > > >
> > > > >     ret = platform_get_irq_optional(...);
> > > > >     if (ret < 0)
> > > > >             return ret;
> > > > >     if (ret > 0)
> > > > >             ...we get an IRQ...
> > > >
> > > > The difference to gpiod_get_optional (and most other *_optional) is that
> > > > you can use the NULL value as if it were a valid GPIO.
> > > >
> > > > As this isn't given with for irqs, I don't think changing the return
> > > > value has much sense.
> > >
> > > We actually want platform_get_irq_optional() to look different to all
> > > the other _optional() methods because it is not equivalent. If it
> > > looks the same, developers will assume it is the same, and get
> > > themselves into trouble.
> >
> > Developers already assume it is the same, and thus forget they have
> > to check against -ENXIO instead of zero.
>
> Is this an ack for renaming platform_get_irq_optional() to
> platform_get_irq_silent()?

No it isn't ;-)

If an optional IRQ is not present, drivers either just ignore it (e.g.
for devices that can have multiple interrupts or a single muxed IRQ),
or they have to resort to polling. For the latter, fall-back handling
is needed elsewhere in the driver.
To me it sounds much more logical for the driver to check if an
optional irq is non-zero (available) or zero (not available), than to
sprinkle around checks for -ENXIO. In addition, you have to remember
that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
(or some other error code) to indicate absence. I thought not having
to care about the actual error code was the main reason behind the
introduction of the *_optional() APIs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
