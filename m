Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F205494234
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245290AbiASU4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:56:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:54135 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbiASU4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 15:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642625797; x=1674161797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zn3K2EdVeDLJCMJ0xbcykPqu/tTiNlke9kM/JdHhcyA=;
  b=UKP5BPWQ+uw2sBH+BM1UqeeTghbHvgaSjb/HR8XqV2m/L0x+YVEmxOGG
   flhgx042uwtvDmyFlbH1w3PHokLzPGv6z+k+i45vi98jaPXt+vr175APx
   AbZt1GcjiOufYlT52vxr4qzItwd0SVdtcN8WG3VZf89UFYd8sgki/FTZ0
   nAJVaJF3b9itTPyNWKR/tIDClRlUTOZwB+qhiCz2ulEGjz2iqqn3ekqLu
   wBY0+mwl9tNWjORFuFbtJE0r88oQiNJ8px6dZJvxRVbsCoXYnnCWjk+qF
   bKdDmFFe8Dlc4vZoy0A9phMp1kTFErGo9dZCebUQjx5RAQ/pMMDiEL2gZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225862988"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="225862988"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:56:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="615845335"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:56:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nAHz3-00CGxM-Ht;
        Wed, 19 Jan 2022 22:55:09 +0200
Date:   Wed, 19 Jan 2022 22:55:09 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
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
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
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
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
        John Garry <john.garry@huawei.com>,
        Takashi Iwai <tiwai@suse.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <Yeh6rdBjEMiavLfh@smile.fi.intel.com>
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
 <YeF05vBOzkN+xYCq@smile.fi.intel.com>
 <20220115154539.j3tsz5ioqexq2yuu@pengutronix.de>
 <YehdsUPiOTwgZywq@smile.fi.intel.com>
 <b7edb713-dd91-14e7-34ff-d8fb559e8e92@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7edb713-dd91-14e7-34ff-d8fb559e8e92@omp.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 10:47:06PM +0300, Sergey Shtylyov wrote:
> On 1/19/22 9:51 PM, Andy Shevchenko wrote:

> >>>>> It'd certainly be good to name anything that doesn't correspond to one
> >>>>> of the existing semantics for the API (!) something different rather
> >>>>> than adding yet another potentially overloaded meaning.
> >>>>
> >>>> It seems we're (at least) three who agree about this. Here is a patch
> >>>> fixing the name.
> >>>
> >>> And similar number of people are on the other side.
> >>
> >> If someone already opposed to the renaming (and not only the name) I
> >> must have missed that.
> >>
> >> So you think it's a good idea to keep the name
> >> platform_get_irq_optional() despite the "not found" value returned by it
> >> isn't usable as if it were a normal irq number?
> > 
> > I meant that on the other side people who are in favour of Sergey's patch.
> > Since that I commented already that I opposed the renaming being a standalone
> > change.
> > 
> > Do you agree that we have several issues with platform_get_irq*() APIs?
> > 
> > 1. The unfortunate naming
> 
>    Mmm, "what's in a name?"... is this the topmost prio issue?

The order is arbitrary.

> > 2. The vIRQ0 handling: a) WARN() followed by b) returned value 0
> 
>    This is the most severe issue, I think...
> 
> > 3. The specific cookie for "IRQ not found, while no error happened" case

-- 
With Best Regards,
Andy Shevchenko


