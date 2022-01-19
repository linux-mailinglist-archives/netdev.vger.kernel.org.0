Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD949414C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 20:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357242AbiASTuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 14:50:10 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:43162 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357176AbiASTuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 14:50:02 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 18DDC20CE456
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "ALSA Development Mailing List" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        <platform-driver-x86@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        "Saravanan Sekar" <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Takashi Iwai <tiwai@suse.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        "Borislav Petkov" <bp@alien8.de>, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "Benson Leung" <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "Richard Weinberger" <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        "Sebastian Reichel" <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <29f0c65d-77f2-e5b2-f6cc-422add8a707d@omp.ru>
 <20220114092557.jrkfx7ihg26ekzci@pengutronix.de>
 <61b80939-357d-14f5-df99-b8d102a4e1a1@omp.ru>
 <20220114202226.ugzklxv4wzr6egwj@pengutronix.de>
 <57af1851-9341-985e-7b28-d2ba86770ecb@omp.ru>
 <20220117084732.cdy2sash5hxp4lwo@pengutronix.de>
 <YehfP23nMd4wn48K@smile.fi.intel.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <fabb8166-e3a9-c48e-073b-cdbbe8c62714@omp.ru>
Date:   Wed, 19 Jan 2022 22:49:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YehfP23nMd4wn48K@smile.fi.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 9:58 PM, Andy Shevchenko wrote:

[...]
>> Because with your change we have:
>>
>>  - < 0 -> error
>>  - == 0 -> no irq
>>  - > 0 -> irq
>>
>> For my part I'd say this doesn't justify the change, but at least I
>> could better life with the reasoning. If you start at:
>>
>> 	irq = platform_get_irq_optional(...)
>> 	if (irq < 0 && irq != -ENXIO)
>> 		return irq
>> 	else if (irq > 0)
>> 		setup_irq(irq);
>> 	else
>> 		setup_polling()
>>
>> I'd change that to
>>
>> 	irq = platform_get_irq_optional(...)
>> 	if (irq > 0) /* or >= 0 ? */
>> 		setup_irq(irq)
>> 	else if (irq == -ENXIO)
>> 		setup_polling()
>> 	else
>> 		return irq
>>
>> This still has to mention -ENXIO, but this is ok and checking for 0 just
>> hardcodes a different return value.
> 
> It's what we are against of. The idea is to have
> 
> 	irq = platform_get_irq_optional(...)
> 	if (irq < 0) // we do not care about special cookies here
> 		return irq;
> 
> 	if (irq)
> 		setup_irq(irq)
> 	else
> 		setup_polling()
> 
> See the difference? Your code is convoluted.

   ... and it's longer when you look at the translated code! :-)

[...]

MBR, Sergey
