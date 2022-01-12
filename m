Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F311048C004
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351660AbiALIeI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Jan 2022 03:34:08 -0500
Received: from mail-ua1-f49.google.com ([209.85.222.49]:41614 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbiALIeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:34:04 -0500
Received: by mail-ua1-f49.google.com with SMTP id p37so3317815uae.8;
        Wed, 12 Jan 2022 00:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=phWLHSZjGguJkLwzqhKqiJsmBiGXyQV/Ve2Tok5pS7g=;
        b=xQ+L+sbnDvIN7pQZoS8oBhJ5hzOFEnlOOpe0OQGj7QGmg7rD/yK5U1MGDB+JbrfrmQ
         Og+LufblsPcyAVbZiGFfqtw3N2LGMeLNEhUeKdnNxSYyOEPDVOTY9uaxHaH7LtUo7nUu
         ZvT/QTfefrqC1vON97MKHf+PjxRKic3ayHsJFD6oS5cU9Z1f7gnSF2qJbpA31ujslifE
         tDhl4Uz+JeZB66TZl0+hAwQWxum4Vlt01A1vgRSNzGq5560NZ2vCuDBsqQpogRY4cL0O
         CcUQMHrLamCovqXDX55XYYap2uK0R+WbsTNj8+rS638rfgH4JfDPr/fLf/9RMA7JbLil
         8mIw==
X-Gm-Message-State: AOAM530bCf0yLZUGo4uESq65lDQwMDIPSwXAwTd0KJYxcY+rNfkltWlc
        SMx9dbIt3QtupXLLf1ZRuArJNDEz+J0gPZMr
X-Google-Smtp-Source: ABdhPJzhw6BMVIlG0RK3C7ZFhyThZLkewdr5PHsq29ggIRCtRT34EBNJubspsNzz4yr+xS05jmWBlw==
X-Received: by 2002:a67:f84e:: with SMTP id b14mr3562668vsp.32.1641976442903;
        Wed, 12 Jan 2022 00:34:02 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id n15sm6569086vkf.35.2022.01.12.00.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 00:34:00 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id m90so3385529uam.2;
        Wed, 12 Jan 2022 00:34:00 -0800 (PST)
X-Received: by 2002:ab0:2118:: with SMTP id d24mr3735076ual.78.1641976440167;
 Wed, 12 Jan 2022 00:34:00 -0800 (PST)
MIME-Version: 1.0
References: <20220110195449.12448-1-s.shtylyov@omp.ru> <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
In-Reply-To: <YdyilpjC6rtz6toJ@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 09:33:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
Message-ID: <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Saravanan Sekar <sravanhome@gmail.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        kvm@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Robert Richter <rric@kernel.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-spi@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jan 10, 2022 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Jan 10, 2022 at 09:10:14PM +0100, Uwe Kleine-König wrote:
> > On Mon, Jan 10, 2022 at 10:54:48PM +0300, Sergey Shtylyov wrote:
> > > This patch is based on the former Andy Shevchenko's patch:
> > >
> > > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
> > >
> > > Currently platform_get_irq_optional() returns an error code even if IRQ
> > > resource simply has not been found. It prevents the callers from being
> > > error code agnostic in their error handling:
> > >
> > >     ret = platform_get_irq_optional(...);
> > >     if (ret < 0 && ret != -ENXIO)
> > >             return ret; // respect deferred probe
> > >     if (ret > 0)
> > >             ...we get an IRQ...
> > >
> > > All other *_optional() APIs seem to return 0 or NULL in case an optional
> > > resource is not available. Let's follow this good example, so that the
> > > callers would look like:
> > >
> > >     ret = platform_get_irq_optional(...);
> > >     if (ret < 0)
> > >             return ret;
> > >     if (ret > 0)
> > >             ...we get an IRQ...
> >
> > The difference to gpiod_get_optional (and most other *_optional) is that
> > you can use the NULL value as if it were a valid GPIO.
> >
> > As this isn't given with for irqs, I don't think changing the return
> > value has much sense.
>
> We actually want platform_get_irq_optional() to look different to all
> the other _optional() methods because it is not equivalent. If it
> looks the same, developers will assume it is the same, and get
> themselves into trouble.

Developers already assume it is the same, and thus forget they have
to check against -ENXIO instead of zero.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
