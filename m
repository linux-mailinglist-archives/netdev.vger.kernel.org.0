Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF3B364171
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbhDSMRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:17:45 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:49693 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239056AbhDSMRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:17:36 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1McIYO-1m4VGN1dSm-00cdhN; Mon, 19 Apr 2021 14:17:03 +0200
Received: by mail-wr1-f45.google.com with SMTP id a4so33804401wrr.2;
        Mon, 19 Apr 2021 05:17:03 -0700 (PDT)
X-Gm-Message-State: AOAM530v/yBC/2XYq7ELiJsOKT38utH8V09hnr+DbReIt0QSUowLKCu9
        qzJPWUNHn5H0Tj77oevy9M0tidTBIegyWgN+ZY8=
X-Google-Smtp-Source: ABdhPJw4F20QerTwfst1rAMwc6NWiXDSUWeUkZ8E4j2sezaYrIv6atAni45jIwUzsYws7AyLO9D3pu8QFGIGztgXd7o=
X-Received: by 2002:a05:6000:1843:: with SMTP id c3mr14679907wri.361.1618834612186;
 Mon, 19 Apr 2021 05:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210419042722.27554-1-alice.guo@oss.nxp.com> <20210419042722.27554-4-alice.guo@oss.nxp.com>
 <YH0O907dfGY9jQRZ@atmark-techno.com> <CAMuHMdVY1SLZ0K30T2pimyrR6Mm=VoSTO=L-xxCy2Bj7_kostw@mail.gmail.com>
 <YH1OeFy+SepIYYG0@atmark-techno.com>
In-Reply-To: <YH1OeFy+SepIYYG0@atmark-techno.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 19 Apr 2021 14:16:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Mu2F0irDDCL-50HiHth29iYFL5b7WHZ=UX6W7zzoxAg@mail.gmail.com>
Message-ID: <CAK8P3a1Mu2F0irDDCL-50HiHth29iYFL5b7WHZ=UX6W7zzoxAg@mail.gmail.com>
Subject: Re: [RFC v1 PATCH 3/3] driver: update all the code that use soc_device_match
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "Alice Guo (OSS)" <alice.guo@oss.nxp.com>,
        gregkh <gregkh@linuxfoundation.org>,
        Rafael Wysocki <rafael@kernel.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        aymen.sghaier@nxp.com, Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        peter.ujfalusi@gmail.com, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>, tomba@kernel.org,
        jyri.sarha@iki.fi, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kishon <kishon@ti.com>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Roy Pledge <Roy.Pledge@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>, dmaengine@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Amlogic Meson SoC support" 
        <linux-amlogic@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-phy@lists.infradead.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-staging@lists.linux.dev,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:P71GUur0c8Et4KTdfK062CelxJMlxDzHdi6foeZVMrh68Tz4kVO
 xXC4vz+qe3LvNC/lTgY8q6jr08cIcxgzzrqqwLuy4gBjPze3CRaFI6Tn0ivsylYkqTjCGCd
 UznPeEk90qstnxb0iWNZx7FG5N+vrUigS/VNsT3W/kFEpTHiyw396kNMzzFJBTjXO+naZJ+
 Cfu35e3pJq/mHwP5LQM/Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tj0dSv4OACg=:QLuHKXqc+6Lj41NGnufoGl
 N+UnlZp25078q227oT0o/4kxbd0mQOAoQ/NCUKgnVsoYmGtmK6mEBskoottCNbYunStcV9NF4
 wE8ToQWQ05B3nZv4Vjj9qNbaiSwQl2/EIEpHx8+6DQaiGM4h6uplPIOIDeaZjltt02tsjjmk7
 kxpSU+zIeAbNwqmXYSk5Vm3CpYS1xMcDA6Eiv0+uZeBUE0kKjN4jwkU6+BKG/eaq+T9ufKwnD
 crSJLI+V67wSaKUzbHccJ3EU1Sb6dMM2cPoEC3Av6tRhuAXiX84+lOxtkljO1IFE9iL1JBVn5
 CjGxqnLONV0vManrkRS3zSk/dqMTqKx9iNczeHNAz+sKCK3kGK1HvvAI82zCriMShj36q2Yiu
 latEFCHqqv6CzIpzD2Q+F98/Rh3nVZdyFAqvuM6r16X0t/3dzAs72dYw+jzCHok5qetil5Q2V
 5rdGScTR8+ZhGbwiKRQyQ6I2CQTnccKZ549zJci96NqNdfUe5jbzVwZOI0walCavZ7GVu0d2F
 jvOU246bo6oNPkDzH9c2gJBnZtcrzAKb4pwtF9+3cOiLZPnCE0nY+1vjm75YQHDBCyxvLdR64
 g4tTIuRlUg3P8XaXbJiPp80y/nkM8kt4yG+up76tnDKMDxMpP5a+pkpQ1YQ2I6y3uojN6bE8n
 CFp8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 11:33 AM Dominique MARTINET
<dominique.martinet@atmark-techno.com> wrote:
> Geert Uytterhoeven wrote on Mon, Apr 19, 2021 at 11:03:24AM +0200:
>
> > soc_device_match() should only be used as a last resort, to identify
> > systems that cannot be identified otherwise.  Typically this is used for
> > quirks, which should only be enabled on a very specific subset of
> > systems.  IMHO such systems should make sure soc_device_match()
> > is available early, by registering their SoC device early.
>
> I definitely agree there, my suggestion to defer was only because I know
> of no other way to influence the ordering of drivers loading reliably
> and gave up on soc being init'd early.

In some cases, you can use the device_link infrastructure to deal
with dependencies between devices. Not sure if this would help
in your case, but have a look at device_link_add() etc in drivers/base/core.c

> In this particular case the problem is that since 7d981405d0fd ("soc:
> imx8m: change to use platform driver") the soc probe tries to use the
> nvmem driver for ocotp fuses for imx8m devices, which isn't ready yet.
> So soc loading gets pushed back to the end of the list because it gets
> defered and other drivers relying on soc_device_match get confused
> because they wrongly think a device doesn't match a quirk when it
> actually does.
>
> If there is a way to ensure the nvmem driver gets loaded before the soc,
> that would also solve the problem nicely, and avoid the need to mess
> with all the ~50 drivers which use it.
>
> Is there a way to control in what order drivers get loaded? Something in
> the dtb perhaps?

For built-in drivers, load order depends on the initcall level and
link order (how things are lined listed in the Makefile hierarchy).

For loadable modules, this is up to user space in the end.

Which of the drivers in this scenario are loadable modules?

        Arnd
