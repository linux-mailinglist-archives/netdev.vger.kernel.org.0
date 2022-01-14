Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD1748EA58
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiANNGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:06:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:42810 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbiANNGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 08:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642165570; x=1673701570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Eo7EfpdrH3wA8s8pzPgaa2QUgdkyHS+qVWfq0/cogWQ=;
  b=TUibVCDD1lMQhtQD/MPJ/IlalGJGZ+o9Xn3zE/4aZNHlWoemmz1CZVRX
   Uc4t32rMHTgl+PhV1LWJQ0p4p254E4BDkqJQMkRfXv0GEajIoUj5R34vJ
   /n+2IK7yjcjPcgO26PoR/eoUA2DaA/1n2pYGGbC04J1QJrRIuBiqzDgC+
   QnrkoszTHNKv2IU40h4CW6Y9rz3j74Xihrzb+We+eea89NSSqu2IOaZlQ
   rugZ+1ZxPwYqBHskwFT/BFUvqzcIS6ods5Z4T04uCC+YOqrc9jHfq2wwf
   aYhMhurAiIlcAzhT/3ykGMl7xRYzGMDf2mvO2W+/DpGIb/QmVsOmxRHyS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244441648"
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="244441648"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 05:06:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="530231083"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 05:05:53 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n8MFy-00AcJJ-9G;
        Fri, 14 Jan 2022 15:04:38 +0200
Date:   Fri, 14 Jan 2022 15:04:38 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
Message-ID: <YeF05vBOzkN+xYCq@smile.fi.intel.com>
References: <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220113194358.xnnbhsoyetihterb@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 08:43:58PM +0100, Uwe Kleine-König wrote:
> The subsystems regulator, clk and gpio have the concept of a dummy
> resource. For regulator, clk and gpio there is a semantic difference
> between the regular _get() function and the _get_optional() variant.
> (One might return the dummy resource, the other won't. Unfortunately
> which one implements which isn't the same for these three.) The
> difference between platform_get_irq() and platform_get_irq_optional() is
> only that the former might emit an error message and the later won't.
> 
> To prevent people's expectations that there is a semantic difference
> between these too, rename platform_get_irq_optional() to
> platform_get_irq_silent() to make the actual difference more obvious.
> 
> The #define for the old name can and should be removed once all patches
> currently in flux still relying on platform_get_irq_optional() are
> fixed.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> On Thu, Jan 13, 2022 at 02:45:30PM +0000, Mark Brown wrote:
> > On Thu, Jan 13, 2022 at 12:08:31PM +0100, Uwe Kleine-König wrote:
> > 
> > > This is all very unfortunate. In my eyes b) is the most sensible
> > > sense, but the past showed that we don't agree here. (The most annoying
> > > part of regulator_get is the warning that is emitted that regularily
> > > makes customers ask what happens here and if this is fixable.)
> > 
> > Fortunately it can be fixed, and it's safer to clearly specify things.
> > The prints are there because when the description is wrong enough to
> > cause things to blow up we can fail to boot or run messily and
> > forgetting to describe some supplies (or typoing so they haven't done
> > that) and people were having a hard time figuring out what might've
> > happened.
> 
> Yes, that's right. I sent a patch for such a warning in 2019 and pinged
> occationally. Still waiting for it to be merged :-\
> (https://lore.kernel.org/r/20190625100412.11815-1-u.kleine-koenig@pengutronix.de)
> 
> > > I think at least c) is easy to resolve because
> > > platform_get_irq_optional() isn't that old yet and mechanically
> > > replacing it by platform_get_irq_silent() should be easy and safe.
> > > And this is orthogonal to the discussion if -ENOXIO is a sensible return
> > > value and if it's as easy as it could be to work with errors on irq
> > > lookups.
> > 
> > It'd certainly be good to name anything that doesn't correspond to one
> > of the existing semantics for the API (!) something different rather
> > than adding yet another potentially overloaded meaning.
> 
> It seems we're (at least) three who agree about this. Here is a patch
> fixing the name.


And similar number of people are on the other side.

-- 
With Best Regards,
Andy Shevchenko


