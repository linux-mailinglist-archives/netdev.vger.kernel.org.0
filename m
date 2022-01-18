Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6263E4922E7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 10:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345696AbiARJhp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 04:37:45 -0500
Received: from mail-ua1-f44.google.com ([209.85.222.44]:44993 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiARJhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 04:37:41 -0500
Received: by mail-ua1-f44.google.com with SMTP id f24so1463520uab.11;
        Tue, 18 Jan 2022 01:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=94RJUajJnozufTpAr/gV3w0KHJpzlohNQuBpMs4wyR0=;
        b=MaJCYAKIZUUHoKESEVDo6QEMbUS0vkztkUHhvTyDRPuvl53gzl04ILCRAu0GnOtVRK
         Fvsqi1dRCWirqq9t3YmOGL8oXLmj/c+ZZFTIODGLKPlzxX8Ns6wHkpRTbSPaEfsZ36u4
         ORN6JM3Oeh3Dc1cjY/4ZEg13C7N7mPArKcEq7Xunw/e8ZvQsNOVSECVOCe87pXr4nh9N
         126uQq6/jbqxCCxq2ZjYt3NQ0u+z0wbgBsZz9KBMihq0jkIt+i5HgIS0vNkewXXXDrgQ
         OYktUJ7DOibltni3K4josLd5pAQEJihshjDkFlMyhvPPj/QLZQ+doQm3IWaMf8wZ+eqx
         yM4w==
X-Gm-Message-State: AOAM533+LPFA5XuBfxDmKTi3x58EAS+txDXKAUOxEGQc+6FNPhMYt6Ro
        qt8Ud413mJQN8fsYU8zZH1yhJ+BVx0cQyYCj
X-Google-Smtp-Source: ABdhPJyw+oic6AsAShUu1MGqZLa67XXZj9G+hQqL+tvjzZ6gUStjqN2CB20oVkNecThrkl9ruBrXVg==
X-Received: by 2002:a9f:2424:: with SMTP id 33mr9064060uaq.67.1642498659372;
        Tue, 18 Jan 2022 01:37:39 -0800 (PST)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id s47sm3681740uad.17.2022.01.18.01.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:37:37 -0800 (PST)
Received: by mail-ua1-f53.google.com with SMTP id c36so35282332uae.13;
        Tue, 18 Jan 2022 01:37:37 -0800 (PST)
X-Received: by 2002:a67:bc17:: with SMTP id t23mr5014894vsn.57.1642498657061;
 Tue, 18 Jan 2022 01:37:37 -0800 (PST)
MIME-Version: 1.0
References: <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru> <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <c9026f17-2b3f-ee94-0ea3-5630f981fbc1@omp.ru> <CAMuHMdXVbRudGs69f9ZzaP1PXhteDNZiXA658eMFAwP4nr9r3w@mail.gmail.com>
 <20220117092444.opoedfcf5k5u6otq@pengutronix.de> <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de> <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de> <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
 <20220118090913.pjumkq4zf4iqtlha@pengutronix.de>
In-Reply-To: <20220118090913.pjumkq4zf4iqtlha@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 18 Jan 2022 10:37:25 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
Message-ID: <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        Eric Auger <eric.auger@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
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

On Tue, Jan 18, 2022 at 10:09 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Tue, Jan 18, 2022 at 09:25:01AM +0100, Geert Uytterhoeven wrote:
> > On Mon, Jan 17, 2022 at 6:06 PM Uwe Kleine-König
> > <u.kleine-koenig@pengutronix.de> wrote:
> > > On Mon, Jan 17, 2022 at 02:08:19PM +0100, Geert Uytterhoeven wrote:
> > > > On Mon, Jan 17, 2022 at 12:49 PM Uwe Kleine-König
> > > > <u.kleine-koenig@pengutronix.de> wrote:
> > > > > > So there are three reasons: because the absence of an optional IRQ
> > > > > > is not an error, and thus that should not cause (a) an error code
> > > > > > to be returned, and (b) an error message to be printed, and (c)
> > > > > > because it can simplify the logic in device drivers.
> > > > >
> > > > > I don't agree to (a). If the value signaling not-found is -ENXIO or 0
> > > > > (or -ENODEV) doesn't matter much. I wouldn't deviate from the return
> > > > > code semantics of platform_get_irq() just for having to check against 0
> > > > > instead of -ENXIO. Zero is then just another magic value.
> > > >
> > > > Zero is a natural magic value (also for pointers).
> > > > Errors are always negative.
> > > > Positive values are cookies (or pointers) associated with success.
> > >
> > > Yeah, the issue where we don't agree is if "not-found" is special enough
> > > to deserve the natural magic value. For me -ENXIO is magic enough to
> > > handle the absence of an irq line. I consider it even the better magic
> > > value.
> >
> > It differs from other subsystems (clk, gpio, reset), which do return
> > zero on not found.
>
> IMHO it doesn't matter at all that the return value is zero, relevant is
> the semantic of the returned value. For clk, gpio, reset and regulator
> NULL is a usable dummy, for irqs it's not. So what you do with the value
> returned by platform_get_irq_whatever() is: you compare it with the
> (magic?) not-found value, and if it matches, you enter a suitable
> if-block.
>
> For the (clk|gpiod|regulator)_get_optional() you don't have to check
> against the magic not-found value (so no implementation detail magic
> leaks into the caller code) and just pass it to the next API function.
> (And my expectation would be that if you chose to represent not-found by
> (void *)66 instead of NULL, you won't have to adapt any user, just the
> framework internal checks. This is a good thing!)

Ah, there is the wrong assumption: drivers sometimes do need to know
if the resource was found, and thus do need to know about (void *)66,
-ENODEV, or -ENXIO.  I already gave examples for IRQ and clk before.
I can imagine these exist for gpiod and regulator, too, as soon as
you go beyond the trivial "enable" and "disable" use-cases.

And 0/NULL vs. > 0 is the natural check here: missing, but not
an error.  Even for IRQ this was envisioned before, when it was
decided that vIRQ zero does not exist.
(Inconsistent) Error codes are not, as missing optional resources
are not error conditions.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
