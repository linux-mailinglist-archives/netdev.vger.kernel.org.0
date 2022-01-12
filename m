Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407BC48C63E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354217AbiALOlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:41:55 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:42834 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354194AbiALOlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:41:51 -0500
Received: by mail-qt1-f173.google.com with SMTP id y17so3182165qtx.9;
        Wed, 12 Jan 2022 06:41:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eqySNHIMSrRvIgAiOM0qBvook97PLGK990KJv8uK3eo=;
        b=uo5AZ07a45C8mgYze+9+LAsur76rvJV1DGpCdlYCi7UZcjbwACwzjc/eblHrNcD7BE
         uHNLEVRxsoeGiabwS9LkZ1ZnZMpb/65FHe3cAojrX37ZWtkZzSrscKxgMEs6/bNvr8Ms
         64BtKLow+fHPHPVp1SWNDrqvFIfaf+3lM8CdnM9IuaGQcg6nDBuZ+PS5lPYIiD0qdv/k
         AQ+inGgdbiDLFdl466ew5JdWho0orVAIftNC8pQOxFZzHnd0yCQqZ8QpZZGfIFq6bKDO
         x/EKh2o3AnBByccsJ0Vue7ubwwFdR/3UeCeZkILSuLcENKFOcnZqgvQOHU3Frws1Ki+c
         0u6Q==
X-Gm-Message-State: AOAM533MvrA+dMe61LdDl6kh4TTdKET+EMfFwEYifStoXaPXqQo184hA
        iVk9xpsp8KTqgNzRXEslNIg5ijuZ3Rzo4S8t63k=
X-Google-Smtp-Source: ABdhPJwkrdKkjqm85M1oqBy+x6EYsmedgIEeAb8RfpkJ1ISYwM2cxFKOOAchYagZSo08mCWlmbsTnHWauUmSmFEGXlM=
X-Received: by 2002:a05:622a:178e:: with SMTP id s14mr7678497qtk.302.1641998509704;
 Wed, 12 Jan 2022 06:41:49 -0800 (PST)
MIME-Version: 1.0
References: <20220110195449.12448-1-s.shtylyov@omp.ru> <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de> <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <Yd7Z3Qwevb/lEwQZ@lunn.ch> <CAMuHMdV2cGvqMppwt9xhpze=pcnHfTozDZMjwT1DkivLD+_nbQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV2cGvqMppwt9xhpze=pcnHfTozDZMjwT1DkivLD+_nbQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 12 Jan 2022 15:41:38 +0100
Message-ID: <CAJZ5v0iyAHtDe1kFObQorXOX0Xraxac0j29Dh+8sq7zxzbsmcQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
        Platform Driver <platform-driver-x86@vger.kernel.org>,
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
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 2:55 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Andrew,
>
> On Wed, Jan 12, 2022 at 2:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > If an optional IRQ is not present, drivers either just ignore it (e.g.
> > > for devices that can have multiple interrupts or a single muxed IRQ),
> > > or they have to resort to polling. For the latter, fall-back handling
> > > is needed elsewhere in the driver.
> > > To me it sounds much more logical for the driver to check if an
> > > optional irq is non-zero (available) or zero (not available), than to
> > > sprinkle around checks for -ENXIO. In addition, you have to remember
> > > that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
> > > (or some other error code) to indicate absence. I thought not having
> > > to care about the actual error code was the main reason behind the
> > > introduction of the *_optional() APIs.
> >
> > The *_optional() functions return an error code if there has been a
> > real error which should be reported up the call stack. This excludes
> > whatever error code indicates the requested resource does not exist,
> > which can be -ENODEV etc. If the device does not exist, a magic cookie
> > is returned which appears to be a valid resources but in fact is
> > not. So the users of these functions just need to check for an error
> > code, and fail the probe if present.
>
> Agreed.
>
> Note that in most (all?) other cases, the return type is a pointer
> (e.g. to struct clk), and NULL is the magic cookie.
>
> > You seems to be suggesting in binary return value: non-zero
> > (available) or zero (not available)
>
> Only in case of success. In case of a real failure, an error code
> must be returned.
>
> > This discards the error code when something goes wrong. That is useful
> > information to have, so we should not be discarding it.
>
> No, the error code must be retained in case of failure.
>
> > IRQ don't currently have a magic cookie value. One option would be to
> > add such a magic cookie to the subsystem. Otherwise, since 0 is
> > invalid, return 0 to indicate the IRQ does not exist.
>
> Exactly. And using 0 means the similar code can be used as for other
> subsystems, where NULL would be returned.
>
> The only remaining difference is the "dummy cookie can be passed
> to other functions" behavior.  Which is IMHO a valid difference,
> as unlike with e.g. clk_prepare_enable(), you do pass extra data to
> request_irq(), and sometimes you do need to handle the absence of
> the interrupt using e.g. polling.
>
> > The request for a script checking this then makes sense. However, i
> > don't know how well coccinelle/sparse can track values across function
> > calls. They probably can check for:
> >
> >    ret = irq_get_optional()
> >    if (ret < 0)
> >       return ret;
> >
> > A missing if < 0 statement somewhere later is very likely to be an
> > error. A comparison of <= 0 is also likely to be an error. A check for
> > > 0 before calling any other IRQ functions would be good. I'm
> > surprised such a check does not already existing in the IRQ API, but
> > there are probably historical reasons for that.
>
> There are still a few platforms where IRQ 0 does exist.

Not just a few even.  This happens on a reasonably recent x86 PC:

rafael@gratch:~/work/linux-pm> head -2 /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
  0:         10          0          0          0          0          0
 IR-IO-APIC    2-edge
timer
