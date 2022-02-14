Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18394B4DCB
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350589AbiBNLO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:14:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350291AbiBNLOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:14:05 -0500
Received: from mxout02.lancloud.ru (mxout02.lancloud.ru [45.84.86.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2337ECC71;
        Mon, 14 Feb 2022 02:43:26 -0800 (PST)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 5B93A232DBED
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH v2 1/2] platform: make platform_get_irq_optional()
 optional
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Corey Minyard <minyard@acm.org>,
        "Oleksij Rempel" <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        "Mun Yew Tham" <mun.yew.tham@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        "Kamal Dasu" <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        "Guenter Roeck" <groeck@chromium.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Takashi Iwai" <tiwai@suse.com>,
        <openipmi-developer@lists.sourceforge.net>,
        <linux-iio@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        <platform-driver-x86@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alsa-devel@alsa-project.org>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
References: <20220212201631.12648-1-s.shtylyov@omp.ru>
 <20220212201631.12648-2-s.shtylyov@omp.ru>
 <CAMuHMdUPxX7Tja6BCjEb4KDobNFPMcM66Fk7Z+VsO7pgb8JnjA@mail.gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <41b49828-e0bc-3e7a-32d7-5ee41c778206@omp.ru>
Date:   Mon, 14 Feb 2022 13:43:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUPxX7Tja6BCjEb4KDobNFPMcM66Fk7Z+VsO7pgb8JnjA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 2/14/22 11:54 AM, Geert Uytterhoeven wrote:

[...]

>> This patch is based on the former Andy Shevchenko's patch:
>>
>> https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
>>
>> Currently platform_get_irq_optional() returns an error code even if IRQ
>> resource simply has not been found.  It prevents the callers from being
>> error code agnostic in their error handling:
>>
>>         ret = platform_get_irq_optional(...);
>>         if (ret < 0 && ret != -ENXIO)
>>                 return ret; // respect deferred probe
>>         if (ret > 0)
>>                 ...we get an IRQ...
>>
>> All other *_optional() APIs seem to return 0 or NULL in case an optional
>> resource is not available.  Let's follow this good example, so that the
>> callers would look like:
>>
>>         ret = platform_get_irq_optional(...);
>>         if (ret < 0)
>>                 return ret;
>>         if (ret > 0)
>>                 ...we get an IRQ...
>>
>> Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>> ---
>> Changes in version 2:
> 
> Thanks for the update!
> 
>>  drivers/base/platform.c                  | 60 +++++++++++++++---------
> 
> The core change LGTM.

   Thanx! :-)

> I'm only looking at Renesas drivers below...
> 
>> --- a/drivers/mmc/host/sh_mmcif.c
>> +++ b/drivers/mmc/host/sh_mmcif.c
>> @@ -1465,14 +1465,14 @@ static int sh_mmcif_probe(struct platform_device *pdev)
>>         sh_mmcif_sync_reset(host);
>>         sh_mmcif_writel(host->addr, MMCIF_CE_INT_MASK, MASK_ALL);
>>
>> -       name = irq[1] < 0 ? dev_name(dev) : "sh_mmc:error";
>> +       name = irq[1] <= 0 ? dev_name(dev) : "sh_mmc:error";
> 
> "== 0" should be sufficient here, if the code above would bail out
> on errors returned by platform_get_irq_optional(), which it currently
> doesn't do.
> As this adds missing error handling, this is to be fixed by a separate
> patch later?

   Yes.

[...]
>>                 ret = devm_request_threaded_irq(dev, irq[1],
>>                                                 sh_mmcif_intr, sh_mmcif_irqt,
>>                                                 0, "sh_mmc:int", host);
> 
>> --- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
>> +++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
>> @@ -439,7 +439,7 @@ static int rcar_gen3_phy_usb2_init(struct phy *p)
>>         u32 val;
>>         int ret;
>>
>> -       if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq >= 0) {
>> +       if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq > 0) {
>>                 INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
>>                 ret = request_irq(channel->irq, rcar_gen3_phy_usb2_irq,
>>                                   IRQF_SHARED, dev_name(channel->dev), channel);
>> @@ -486,7 +486,7 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
>>                 val &= ~USB2_INT_ENABLE_UCOM_INTEN;
>>         writel(val, usb2_base + USB2_INT_ENABLE);
>>
>> -       if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
>> +       if (channel->irq > 0 && !rcar_gen3_is_any_rphy_initialized(channel))
>>                 free_irq(channel->irq, channel);
>>
>>         return 0;
> 
> LGTM, but note that all errors returned by platform_get_irq_optional()
> are currently ignored, even real errors, which should be propagated
> up.
> As this adds missing error handling, this is to be fixed by a separate
> patch later?

   Yes.

>> --- a/drivers/thermal/rcar_gen3_thermal.c
>> +++ b/drivers/thermal/rcar_gen3_thermal.c
>> @@ -432,6 +432,8 @@ static int rcar_gen3_thermal_request_irqs(struct rcar_gen3_thermal_priv *priv,
>>                 irq = platform_get_irq_optional(pdev, i);
>>                 if (irq < 0)
>>                         return irq;
>> +               if (!irq)
>> +                       return -ENXIO;
> 
> While correct, and preserving existing behavior, this looks strange
> to me.  Probably this should return zero instead (i.e. the check
> above should be changed to "<= 0"), and the caller should start caring
> about and propagating up real errors.

   Hm, you're right... should be <= 0 there, it seems.

> As this adds missing error handling, this is to be fixed by a separate
> patch later?

   Propagating errors from the probe() method is a matter of separate patch, yes.

>>
>>                 irqname = devm_kasprintf(dev, GFP_KERNEL, "%s:ch%d",
>>                                          dev_name(dev), i);
>> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
>> index fb65dc601b23..328ab074fd89 100644
> 
>> --- a/drivers/tty/serial/sh-sci.c
>> +++ b/drivers/tty/serial/sh-sci.c
> 
> I think you missed
> 
>     #define SCIx_IRQ_IS_MUXED(port)                 \
>             ((port)->irqs[SCIx_ERI_IRQ] ==  \
>              (port)->irqs[SCIx_RXI_IRQ]) || \
>             ((port)->irqs[SCIx_ERI_IRQ] &&  \
>              ((port)->irqs[SCIx_RXI_IRQ] < 0))
> 
> above? The last condition should become "<= 0".

   Yes, probably... TY!

> Gr{oetje,eeting}s,
> 
>                         Geert

MBR, Sergey
