Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C8C4939CD
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 12:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354299AbiASLm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 06:42:26 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:32826 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiASLmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 06:42:19 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 3B47720D46BF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
 (summary)
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        <openipmi-developer@lists.sourceforge.net>,
        "Khuong Dinh" <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        "Jiri Slaby" <jirislaby@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-serial@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Jaroslav Kysela" <perex@perex.cz>, <linux-pwm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>, <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "John Garry" <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Sebastian Reichel" <sre@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Takashi Iwai" <tiwai@suse.com>,
        <platform-driver-x86@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>,
        "Vinod Koul" <vkoul@kernel.org>, James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220115183643.6zxalxqxrhkfgdfq@pengutronix.de> <YeQpWu2sUVOSaT9I@kroah.com>
 <20220118091819.zzxpffrxbckoxiys@pengutronix.de>
 <b6038ec2-da4a-de92-b845-cac2be0efcd1@omp.ru>
 <20220119113314.tpqfdgi6nurmzfun@pengutronix.de>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <a42e1c8b-2c3d-e3f2-e48c-ad145322ad3d@omp.ru>
Date:   Wed, 19 Jan 2022 14:42:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220119113314.tpqfdgi6nurmzfun@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 2:33 PM, Uwe Kleine-König wrote:

[...]
>>>>> A possible compromise: We can have both. We rename
>>>>> platform_get_irq_optional() to platform_get_irq_silent() (or
>>>>> platform_get_irq_silently() if this is preferred) and once all users are
>>>>> are changed (which can be done mechanically), we reintroduce a
>>>>> platform_get_irq_optional() with Sergey's suggested semantic (i.e.
>>>>> return 0 on not-found, no error message printking).
>>>>
>>>> Please do not do that as anyone trying to forward-port an old driver
>>>> will miss the abi change of functionality and get confused.  Make
>>>> build-breaking changes, if the way a function currently works is
>>>> changed in order to give people a chance.
>>>
>>> Fine for me. I assume this is a Nack for Sergey's patch?
>>
>>    Which patch do you mean? I'm starting to get really muddled... :-(
> 
> I'm talking about "[PATCH 1/2] platform: make
> platform_get_irq_optional() optional"

   I thought GregKH was talking about your renaming patch... :-/

> because "trying to forward-port an
> old driver will miss the abi" applies to it.

   Mhm... why not tell me right from the start? Jr even tell that to Andy
instead of merging his patch, so I wouldn't get sucked into this work? 
I wouldn't bother with v2 and it would have saved a lot of time spent on
email... :-(
   Do we also remember that "the stable API is a nonsense" thing? :-)

> Best regards
> Uwe

MBR, Sergey
