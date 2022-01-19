Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB87493E25
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356147AbiASQMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:12:44 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:42292 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355919AbiASQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:12:34 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru AA47520A2ADD
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Mark Brown" <broonie@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <openipmi-developer@lists.sourceforge.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, "Tony Luck" <tony.luck@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
References: <20220117092444.opoedfcf5k5u6otq@pengutronix.de>
 <CAMuHMdUgZUeraHadRAi2Z=DV+NuNBrKPkmAKsvFvir2MuquVoA@mail.gmail.com>
 <20220117114923.d5vajgitxneec7j7@pengutronix.de>
 <CAMuHMdWCKERO20R2iVHq8P=BaoauoBAtiampWzfMRYihi3Sb0g@mail.gmail.com>
 <20220117170609.yxaamvqdkivs56ju@pengutronix.de>
 <CAMuHMdXbuZqEpYivyS6hkaRN+CwTOGaHq_OROwVAWvDD6OXODQ@mail.gmail.com>
 <20220118090913.pjumkq4zf4iqtlha@pengutronix.de>
 <CAMuHMdUW8+Y_=uszD+JOZO3Lpa9oDayk+GO+cg276i2f2T285w@mail.gmail.com>
 <20220118120806.pbjsat4ulg3vnhsh@pengutronix.de>
 <CAMuHMdWkwV9XE_R5FZ=jPtDwLpDbEngG6+X2JmiDJCZJZvUjYA@mail.gmail.com>
 <20220118142945.6y3rmvzt44pjpr4z@pengutronix.de>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <6370798a-7a7e-243d-99f9-09bf772ddbac@omp.ru>
Date:   Wed, 19 Jan 2022 19:12:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220118142945.6y3rmvzt44pjpr4z@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 5:29 PM, Uwe Kleine-König wrote:

>> nst the magic not-found value (so no implementation detail magic
>>>>> leaks into the caller code) and just pass it to the next API function=
>> .
>>>>> (And my expectation would be that if you chose to represent not-found=
>>  by
>>>>> (void *)66 instead of NULL, you won't have to adapt any user, just th=
>> e
>>>>> framework internal checks. This is a good thing!)
>>>>
>>>> Ah, there is the wrong assumption: drivers sometimes do need to know
>>>> if the resource was found, and thus do need to know about (void *)66,
>>>> -ENODEV, or -ENXIO.  I already gave examples for IRQ and clk before.
>>>> I can imagine these exist for gpiod and regulator, too, as soon as
>>>> you go beyond the trivial "enable" and "disable" use-cases.
>>>
>>> My premise is that every user who has to check for "not found"
>>> explicitly should not use (clk|gpiod)_get_optional() but
>>> (clk|gpiod)_get() and do proper (and explicit) error handling for
>>> -ENODEV. (clk|gpiod)_get_optional() is only for these trivial use-cases.
>>>
>>>> And 0/NULL vs. > 0 is the natural check here: missing, but not
>>>> an error.
>>>
>>> For me it it 100% irrelevant if "not found" is an error for the query
>>> function or not. I just have to be able to check for "not found" and
>>> react accordingly.
>>>
>>> And adding a function
>>>
>>>         def platform_get_irq_opional():
>>>                 ret =3D platform_get_irq()
>>>                 if ret =3D=3D -ENXIO:
>>>                         return 0
>>>                 return ret
>>>
>>> it's not a useful addition to the API if I cannot use 0 as a dummy
>>> because it doesn't simplify the caller enough to justify the additional
>>> function.
>>>
>>> The only thing I need to be able is to distinguish the cases "there is
>>> an irq", "there is no irq" and anything else is "there is a problem I
>>> cannot handle and so forward it to my caller". The semantic of
>>> platform_get_irq() is able to satisfy this requirement[1], so why introdu=
>> ce
>>> platform_get_irq_opional() for the small advantage that I can check for
>>> not-found using
>>>
>>>         if (!irq)
>>>
>>> instead of
>>>
>>>         if (irq !=3D -ENXIO)
>>>
>>> ? The semantic of platform_get_irq() is easier ("Either a usable
>>> non-negative irq number or a negative error number") compared to
>>> platform_get_irq_optional() ("Either a usable positive irq number or a
>>> negative error number or 0 meaning not found"). Usage of
>>> platform_get_irq() isn't harder or more expensive (neither for a human
>>> reader nor for a maching running the resulting compiled code).
>>> For a human reader
>>>
>>>         if (irq !=3D -ENXIO)
>>>
>>> is even easier to understand because for
>>>
>>>         if (!irq)
>>>
>>> they have to check where the value comes from, see it's
>>> platform_get_irq_optional() and understand that 0 means not-found.
>>
>> "vIRQ zero does not exist."
> 
> With that statement in mind I would expect that a function that gives me
> an (v)irq number never returns 0.
> 
>>> This function just adds overhead because as a irq framework user I have
>>> to understand another function. For me the added benefit is too small to
>>> justify the additional function. And you break out-of-tree drivers.
>>> These are all no major counter arguments, but as the advantage isn't
>>> major either, they still matter.
>>>
>>> Best regards
>>> Uwe
>>>
>>> [1] the only annoying thing is the error message.
>>
>> So there's still a need for two functions.
> 
> Or a single function not emitting an error message together with the
> callers being responsible for calling dev_err().
> 
> So the options in my preference order (first is best) are:
> 
>  - Remove the printk from platform_get_irq() and remove
>    platform_get_irq_optional();

   Strong NAK here:
- dev_err() in our function saves a lot of (repeatable!) comments;
- we've already discussed that it's more optimal to check againt 0 than
  against -ENXIO in the callers.

>  - Rename platform_get_irq_optional() to platform_get_irq_silently()

   NAK as well. We'd better off complaining about irq < 0 in this function.

>  - Keep platform_get_irq_optional() as is

   NAK, it's suboptimal in the call sites.

>  - Collect underpants
> 
>  - ?

   You're on your own here. :-)

>  - Change semantic of platform_get_irq_optional()

   Yes, we should change the semantics if it serves our goals better. 

> Best regards
> Uwe

MBR, Sergey
