Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8226490425
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 09:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbiAQImC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 03:42:02 -0500
Received: from mail-ua1-f46.google.com ([209.85.222.46]:41523 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiAQIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 03:41:58 -0500
Received: by mail-ua1-f46.google.com with SMTP id i10so7119199uab.8;
        Mon, 17 Jan 2022 00:41:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HSt6CNnm0GlM6Pd+PH2cbsXZ5sf+8uWh7XWO1e+2zQ0=;
        b=sKBXG2mWwu3n6g8h5iQfQQnvAy5XhEZAuQzRMowpD9CulpcxdhPmnA++mJ2Eyi+P1B
         ZQMQCvpixugKhcpQEod+w5pGrI8LXhC3J/KGxjPu1Vgjky33FQ1B+ht+CB0kDsFJns7i
         /6jJJtrJ7sBMcKIhthCci5Z4Byuwo7N0PtPOZlLTY6nzLmaVKfzaEgWwwrPbkSdlFyEY
         JBV7v6b7gPvvBK/czjRRHsdCEmbd/cmtxnYSM84wuFGwtNFwV6kxIQPNNd4EdqS4go0m
         yz9PavcnQ4BhJJtpVtLbJacYHHQH04uRCOMaxxo255LIhTN4aEwud8udQsLX2dJP+qyj
         vBpQ==
X-Gm-Message-State: AOAM531WMoW5MbVpJR0w9OlcGuO38k8lAFsIA3Hhwya0RohMXZ0/vCdX
        HG3jXuVTUmKIaJMNctP1XwyVKuKdDw3xvmaT
X-Google-Smtp-Source: ABdhPJzuBASQlJADwbQwyuvqhYqzO+kBA0KWenHCdq+XFyIwsNF6bJewroQ6BVu1fHv/IyoZ4Arybg==
X-Received: by 2002:a67:c911:: with SMTP id w17mr7111347vsk.23.1642408916533;
        Mon, 17 Jan 2022 00:41:56 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id d124sm3598622vkb.9.2022.01.17.00.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:41:54 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id p1so29035875uap.9;
        Mon, 17 Jan 2022 00:41:54 -0800 (PST)
X-Received: by 2002:ab0:4d42:: with SMTP id k2mr5629977uag.78.1642408914153;
 Mon, 17 Jan 2022 00:41:54 -0800 (PST)
MIME-Version: 1.0
References: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch> <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de> <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru> <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru> <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
In-Reply-To: <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 17 Jan 2022 09:41:42 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
Message-ID: <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 15, 2022 at 9:22 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> On 1/14/22 11:22 PM, Uwe Kleine-König wrote:
> > You have to understand that for clk (and regulator and gpiod) NULL is a
> > valid descriptor that can actually be used, it just has no effect. So
> > this is a convenience value for the case "If the clk/regulator/gpiod in
> > question isn't available, there is nothing to do". This is what makes
> > clk_get_optional() and the others really useful and justifies their
> > existence. This doesn't apply to platform_get_irq_optional().
>
>    I do understand that. However, IRQs are a different beast with their
> own justifications...

> > clk_get_optional() is sane and sensible for cases where the clk might be
> > absent and it helps you because you don't have to differentiate between
> > "not found" and "there is an actual resource".
> >
> > The reason for platform_get_irq_optional()'s existence is just that
> > platform_get_irq() emits an error message which is wrong or suboptimal
>
>    I think you are very wrong here. The real reason is to simplify the
> callers.

Indeed.

Even for clocks, you cannot assume that you can always blindly use
the returned dummy (actually a NULL pointer) to call into the clk
API.  While this works fine for simple use cases, where you just
want to enable/disable an optional clock (clk_prepare_enable() and
clk_disable_unprepare()), it does not work for more complex use cases.

Consider a device with multiple clock inputs, some of them optional,
where the device driver has to find, select and configure a suitable
clock to operate at a certain clock frequency. The driver can call
clk_get_rate(NULL) fine, but will always receive a zero rate, so it
has to check for this (regardless of this being a dummy clock or not,
because this could be an unpopulated clock crystal, which would be
described in DT as a (present) fixed-rate clock with clock-frequency
= <0>).
For configuring the clock rate, the driver does need to check
explicitly for the presence of a dummy clock, as clk_set_rate(NULL,
rate) returns 0 ("success"), while obviously it didn't do anything,
and thus configuring the device to use that clock would cause breakage.

You can check if the clock is a real clock or a dummy using
"if (clk) ...".
And you'd use the same pattern with platform_irq_get_optional() if it
would return 0 if the IRQ was not found: "if (irq) ...".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
