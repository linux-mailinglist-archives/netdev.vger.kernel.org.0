Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA0493903
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353553AbiASK4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:56:25 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:57474 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbiASK4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:56:21 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru A771820D27E6
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
 (summary)
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        <alsa-devel@alsa-project.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "Guenter Roeck" <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        <linux-phy@lists.infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Tony Luck" <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-serial@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <platform-driver-x86@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        "Saravanan Sekar" <sravanhome@gmail.com>,
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
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        <openipmi-developer@lists.sourceforge.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-edac@vger.kernel.org>,
        "Richard Weinberger" <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>, <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        <linux-mediatek@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220115183643.6zxalxqxrhkfgdfq@pengutronix.de> <YeQpWu2sUVOSaT9I@kroah.com>
 <20220118091819.zzxpffrxbckoxiys@pengutronix.de>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b6038ec2-da4a-de92-b845-cac2be0efcd1@omp.ru>
Date:   Wed, 19 Jan 2022 13:56:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220118091819.zzxpffrxbckoxiys@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 12:18 PM, Uwe Kleine-König wrote:
> On Sun, Jan 16, 2022 at 03:19:06PM +0100, Greg Kroah-Hartman wrote:
>> On Sat, Jan 15, 2022 at 07:36:43PM +0100, Uwe Kleine-König wrote:
>>> A possible compromise: We can have both. We rename
>>> platform_get_irq_optional() to platform_get_irq_silent() (or
>>> platform_get_irq_silently() if this is preferred) and once all users are
>>> are changed (which can be done mechanically), we reintroduce a
>>> platform_get_irq_optional() with Sergey's suggested semantic (i.e.
>>> return 0 on not-found, no error message printking).
>>
>> Please do not do that as anyone trying to forward-port an old driver
>> will miss the abi change of functionality and get confused.  Make
>> build-breaking changes, if the way a function currently works is
>> changed in order to give people a chance.
> 
> Fine for me. I assume this is a Nack for Sergey's patch?

   Which patch do you mean? I'm starting to get really muddled... :-(

> Best regards
> Uwe

MBR, Sergey
